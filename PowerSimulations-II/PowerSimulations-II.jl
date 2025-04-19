# Import Required Packages
using PowerSystemCaseBuilder
using PowerSystems
using PowerSimulations
using HydroPowerSimulations
using StorageSystemsSimulations
using HiGHS
using Dates

# Multi-Stage
sys_rts_da = build_system(PSISystems, "modified_RTS_GMLC_DA_sys");
sys_rts_rt = build_system(PSISystems, "modified_RTS_GMLC_RT_sys");

transform_single_time_series!(sys_rts_da, Hour(48), Hour(24))
transform_single_time_series!(sys_rts_rt, Hour(1), Minute(15))

solver = optimizer_with_attributes(HiGHS.Optimizer,
                                   "time_limit"=>25000.0, 
                                   "mip_abs_gap"=>1e-5,
                                   "log_to_console" => false)

template_uc = template_unit_commitment(; network = NetworkModel(PTDFPowerModel, use_slacks = true))
template_rt = template_economic_dispatch(; network = NetworkModel(PTDFPowerModel, use_slacks = true))

models = SimulationModels(
    decision_models=[
        DecisionModel(template_uc,
            sys_rts_da,
            name="UC",
            optimizer=solver,
            initialize_model=false,
            optimizer_solve_log_print=true,
            direct_mode_optimizer=true,
            check_numerical_bounds=false,
            warm_start=true,
        ),
        DecisionModel(template_rt,
            sys_rts_rt,
            name="RT",
            optimizer=solver,
            initialize_model=false,
            optimizer_solve_log_print=true,
            direct_mode_optimizer=true,
            check_numerical_bounds=false,
            warm_start=true,
        ),
    ],
)

sequence = SimulationSequence(
    models=models,
    feedforwards=Dict(
        "RT" => [
            SemiContinuousFeedforward(;
                component_type = ThermalStandard,
                source = OnVariable,
                affected_values = [ActivePowerVariable],
            ),
        ],
    ),
    ini_cond_chronology=InterProblemChronology(),
)
                               
sim = Simulation(
    name = "RTS_MultiStage_CP_Demo",
    steps = 1,
    models = models,
    sequence = sequence,
    initial_time = initial_time,
    simulation_folder = ".",
)
build_out = build!(sim; serialize = false)
execute!(sim, enable_progress_bar = true)

results = SimulationResults(sim);
results_uc = PSI.get_decision_problem_results(results, "UC");
variables = PSI.read_realized_variables(results_uc);
variables["OnVariable__ThermalStandard"]


