# Import Required Packages
using PowerSystemCaseBuilder
using PowerSystems
using PowerSimulations
using HydroPowerSimulations
using StorageSystemsSimulations
using HiGHS
using Dates

# Build RTS-GMLC System using PSB
rts_da_sys = build_system(PSISystems, "modified_RTS_GMLC_DA_sys");

# Operation Simulations/ System Scheduling
# Single-Stage
# Template
# Solver - HiGHS
solver = optimizer_with_attributes(HiGHS.Optimizer,
                                   "time_limit"=>25000.0, 
                                   "mip_abs_gap"=>1e-5,
                                   "log_to_console" => false)
horizon = Hour(24)  # The time horizon of the uc problem is 24 hours

# build UC model
initial_time = DateTime("2020-01-01");
template = ProblemTemplate();

# Network Models 
set_network_model!(
      template,
      NetworkModel(CopperPlatePowerModel, duals = [CopperPlateBalanceConstraint], use_slacks = true),
  )

# AC Branch Models
set_device_model!(template, Line, StaticBranchUnbounded)
set_device_model!(template, Transformer2W, StaticBranchUnbounded)
set_device_model!(template, TapTransformer, StaticBranchUnbounded)
set_device_model!(template, TwoTerminalHVDCLine, HVDCTwoTerminalUnbounded)


# ThermalGen
set_device_model!(template, ThermalStandard, ThermalStandardUnitCommitment)

# RenewableGen
set_device_model!(template, RenewableDispatch, RenewableFullDispatch)
set_device_model!(template, RenewableNonDispatch, FixedOutput)

# Loads
set_device_model!(template, PowerLoad, StaticPowerLoad)

# Reserves
set_service_model!(template, VariableReserve{ReserveUp}, RangeReserve)
set_service_model!(template, VariableReserve{ReserveDown}, RangeReserve)

# HydroGen
set_device_model!(template, HydroDispatch, HydroDispatchRunOfRiver)

# Set system units to natural units or megawats
set_units_base_system!(rts_da_sys, "NATURAL_UNITS");


# Setting up the simulation
# With Initialization
op_problem = DecisionModel(template, rts_da_sys; 
                           name = "UC", 
                           optimizer = solver, 
                           horizon = horizon, 
                           initial_time = initial_time, 
                           store_variable_names = true, 
                           optimizer_solve_log_print=true, 
                           initialize_model=true)

models = SimulationModels(decision_models = [op_problem],)
sequence = SimulationSequence(models = models,)

sim = Simulation(
    name = "RTS_SingleStage_CP_Demo", 
    steps = 1,
    models = models,
    sequence = sequence,
    initial_time = initial_time,
    simulation_folder = ".",
)
build_out = build!(sim;serialize = false)
execute!(sim, enable_progress_bar=true)

# Access Results
results = SimulationResults(sim; ignore_status=true);
results_uc = get_decision_problem_results(results, "UC")

thermal_gen_status = read_realized_variable(results_uc, "OnVariable__ThermalStandard")
slack_up_vals = read_realized_variable(results_uc, "SystemBalanceSlackUp__System")

# Optimizer Stats
optimizer_stats = read_optimizer_stats(results_uc)
total_solve_time = sum(optimizer_stats[!, "solve_time"])
total_solve_time_hours = total_solve_time / 3600

# Duals
duals_results = read_realized_duals(results_uc)
duals_results["CopperPlateBalanceConstraint__System"]
# Different Network Model
# DC PF
solver = optimizer_with_attributes(HiGHS.Optimizer,
                                   "time_limit"=>25000.0, 
                                   "mip_abs_gap"=>1e-5,
                                   "log_to_console" => true)
horizon = Hour(24)  # The time horizon of the uc problem is 24 hours

# build UC model
initial_time = DateTime("2020-01-01");
template = ProblemTemplate();

set_network_model!(
      template,
      NetworkModel(DCPPowerModel, duals = [NodalBalanceActiveConstraint], use_slacks = true),
  )

# AC Branch Models
set_device_model!(template, Line, StaticBranch)
set_device_model!(template, Transformer2W, StaticBranch)
set_device_model!(template, TapTransformer, StaticBranch)
set_device_model!(template, TwoTerminalHVDCLine, HVDCTwoTerminalDispatch)


# ThermalGen
set_device_model!(template, ThermalStandard, ThermalBasicUnitCommitment)

# RenewableGen
set_device_model!(template, RenewableDispatch, RenewableFullDispatch)
set_device_model!(template, RenewableNonDispatch, FixedOutput)

# Loads
set_device_model!(template, PowerLoad, StaticPowerLoad)

# Reserves
set_service_model!(template, VariableReserve{ReserveUp}, RangeReserve)
set_service_model!(template, VariableReserve{ReserveDown}, RangeReserve)

# HydroGen
set_device_model!(template, HydroDispatch, HydroDispatchRunOfRiver)

# Set system units to natural units or megawats
set_units_base_system!(rts_da_sys, "NATURAL_UNITS");


# Setting up the simulation
# With Initialization
op_problem = DecisionModel(template, rts_da_sys; 
                           name = "UC", 
                           optimizer = solver, 
                           horizon = horizon, 
                           initial_time = initial_time, 
                           store_variable_names = true, 
                           optimizer_solve_log_print=true, 
                           initialize_model=true)

models = SimulationModels(decision_models = [op_problem],)
sequence = SimulationSequence(models = models,)

sim = Simulation(
    name = "RTS_SingleStage_DCP_Demo", 
    steps = 1,
    models = models,
    sequence = sequence,
    initial_time = initial_time,
    simulation_folder = ".",
)
build_out = build!(sim;serialize = false)
execute!(sim, enable_progress_bar=true)

# Access Results
results = SimulationResults(sim; ignore_status=true);
results_uc = get_decision_problem_results(results, "UC")

thermal_gen_status = read_realized_variable(results_uc, "OnVariable__ThermalStandard")
slack_up_vals = read_realized_variable(results_uc, "SystemBalanceSlackUp__ACBus")

# Optimizer Stats
optimizer_stats = read_optimizer_stats(results_uc)
total_solve_time = sum(optimizer_stats[!, "solve_time"])
total_solve_time_hours = total_solve_time / 3600

# Duals
duals_results = read_realized_duals(results_uc)
duals_results["NodalBalanceActiveConstraint__ACBus"]




