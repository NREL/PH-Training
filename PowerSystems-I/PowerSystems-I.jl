# ----------------------------------------------
# Part - 1: Using PowerSystemCaseBuilder
# ----------------------------------------------
using PowerSystems
using PowerSystemCaseBuilder
const PSB = PowerSystemCaseBuilder
const PSY = PowerSystems
# Introduction
# In this script, we will use the PowerSystemsCaseBuilder.jl package,
# which hosts a curated set of test systems. These test systems serve two
# main purposes: 1) They help the Sienna development team test new features.
# 2) They provide users access to these test systems to begin their journey
# of learning and exploring Sienna.

# Step 1: Show all categories
# Let's see what categories are available for these test systems.
show_categories()

# Step 2: Show all systems for all categories
# We can start by listing all the available test systems.
show_systems()

# Step 3: Show all systems for one category
# Now, let's explore the systems within a specific category, e.g., PSYTestSystems.
show_systems(PSYTestSystems)

# Step 4: Build a system
# Let's build a specific system from the available test systems.
# Two key arguments that users need to be aware of are:
# 1) `time_series_directory`: It isn't required when running on a local
# machine but is necessary when running on NREL's HPC systems (Eagle or
# Kestrel). Users should pass `time_series_directory="/tmp/scratch"`.
# 2) `time_series_read_only`: This option loads the system in read-only
# mode, which helps when loading large datasets. Don't use this if you want
# to edit time series information.
# The first system is the RTS Day-ahead system that contains hourly time
# series data.
if ~isdir(joinpath(@__DIR__,"data"))
    mkpath(joinpath(@__DIR__,"data"))
end

sys_da = PSB.build_system(PSISystems, "modified_RTS_GMLC_DA_sys")
# The second system is the RTS Real-time system that contains 5-minute
# time series data.
sys_rt = PSB.build_system(PSISystems, "modified_RTS_GMLC_RT_sys")

# Step 5: Save the system to JSON
# We can save the system data to a JSON file for further analysis.
PSY.to_json(sys_da, "data/RTS_GMLC_DA.json", pretty = true)
PSY.to_json(sys_rt, "data/RTS_GMLC_RT.json", pretty = true)

# Accessing Test Data Setup:
# --------------------
# Several RAW file examples are available, but here, we'll copy the current set.
readdir(joinpath(PSB.DATA_DIR, "psse_raw"))

# Copy the RTS-GMLC raw file to our data directory.
cp(joinpath(PSB.DATA_DIR, "psse_raw", "RTS-GMLC.RAW"), "data/RTS-GMLC.RAW")

# Similarly, copy the RTS-GMLC MATPOWER file.
readdir(joinpath(PSB.DATA_DIR, "matpower"))
cp(joinpath(PSB.DATA_DIR, "matpower", "RTS_GMLC.m"), "data/RTS_GMLC.m")

# Copy all RTS-GMLC data.
RTS_GMLC_DIR = joinpath(PSB.DATA_DIR, "RTS_GMLC")
cp(RTS_GMLC_DIR, "data/RTS_GMLC")

# ----------------------------------------------
# Part - 2: Parsing Power System Data
# ----------------------------------------------
using PowerSystems
using PowerSystemCaseBuilder
using Dates

const PSB = PowerSystemCaseBuilder
const PSY = PowerSystems

# Parsing Files:
# --------------
# We'll parse different formats to create an initial Sienna System Object, 
# leveraging PowerSystems.jl's built-in parsing capability.

# Example 1: Parsing a PSSE RAW File
# PSSE primarily stores network-related info. Devices will be parsed as 
# ThermalStandard, which can later be converted to other generator types. 
# The parser currently supports up to v33 of the PSSE RAW format.
sys_psse = System("./data/RTS-GMLC.RAW")

# Example 2: Parsing a Matpower .m File
# Comprehensive data in Matpower allows for a complete PCM system build in one step.
sys_matpower = System("./data/RTS_GMLC.m")

# Example 3: Parsing Tabular Data Format
# This format uses .CSV files for each infrastructure type (e.g., bus.csv). 
# It also supports parsing of time series data. The format allows flexibility in 
# data representation and storage.
#=
This parser will be deprecated sometime in the fall of 2024. `PowerSystems.jl` will be
moving to a database solution for handling data. There are plans to eventually include
utility functions to translate from .csv files to the database, but there will probably
be a gap in support. **Users are recommended to write their own custom Julia code to
import data from their unique data formats, rather than relying on this parsing
code.**
=#
rawsys = PSY.PowerSystemTableData(
    RTS_GMLC_DIR,
    100.0,
    joinpath(RTS_GMLC_DIR, "user_descriptors.yaml");
    timeseries_metadata_file = joinpath(RTS_GMLC_DIR, "timeseries_pointers.json"),
    generator_mapping_file = joinpath(RTS_GMLC_DIR, "generator_mapping.yaml"),
)
sys = PSY.System(rawsys; time_series_resolution = Dates.Hour(1))
PSY.transform_single_time_series!(sys, Dates.Hour(24), Dates.Hour(24))

# ----------------------------------------------
# Part - 3 : Customization to Tabular Data Parser
# Example configuration files
# user_descriptors.yaml - https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml
# generator_mapping.yaml - https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/generator_mapping.yaml
# ----------------------------------------------
data_dir = "/data/my-data-dir"
base_power = 100.0
descriptors = "./user_descriptors.yaml"
timeseries_metadata_file = "./timeseries_pointers.json"
generator_mapping_file = "./generator_mapping.yaml"
data = PowerSystemTableData(
    data_dir,
    base_power,
    descriptors;
    timeseries_metadata_file = timeseries_metadata_file,
    generator_mapping_file = generator_mapping_file,
)
sys = System(data; time_series_in_memory = true)

# Extending tabular data parser
function demo_bus_csv_parser!(data::PowerSystemTableData)
    for bus in iterate_rows(data, BUS::InputCategory)
        @show bus.name, bus.max_active_power, bus.max_reactive_power
    end
end

# ----------------------------------------------
# Part - 4 : Adding time series data from CSV's
# ----------------------------------------------
using PowerSystems
using JSON3

file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data");
sys = System(joinpath(file_dir, "case5_re.m"));

using PowerSystemCaseBuilder 
DATA_DIR = PowerSystemCaseBuilder.DATA_DIR 
FORECASTS_DIR = joinpath(DATA_DIR, "5-Bus", "5bus_ts"); 
fname = joinpath(FORECASTS_DIR, "timeseries_pointers_da.json"); 
open(fname, "r") do f 
    JSON3.@pretty JSON3.read(f) 
end 

fname = joinpath(FORECASTS_DIR, "timeseries_pointers_da.json")
add_time_series!(sys, fname)

# ----------------------------------------------
# Part - 5 : getting buses and generators in a System
# ----------------------------------------------
# Option 1a: Get an iterator for all the buses
bus_iter = get_components(ACBus, system)

for b in bus_iter
    set_base_voltage!(b, 330.0)
end

# Option 1b: Get a vector of all the buses
buses = collect(get_components(ACBus, system))

# Option 2a: Get the buses in an Area or LoadZone
show_components(Area, system) # See available Areas
area2 = get_component(Area, system, "2"); # Get Area named 2
area_buses = get_buses(system, area2)

PSY.get_aggregation_topology_mapping(PSY.Area, sys)

# Option 2b: Get buses by ID number
buses_by_ID = get_buses(system, Set(101:110))

get_number.(get_components(ACBus, system))

# Using get_available_components to get an iterator
gen_iter = get_available_components(Generator, system)
get_name.(gen_iter)

# We could also get a certain subtype of Generator
gen_iter = get_available_components(RenewableDispatch, system)

# Using get_available_components to get a vector
gens = collect(get_available_components(Generator, system));

# Using get_components to get an iterator
gen_iter = get_components(get_available, Generator, system)

# ----------------------------------------------
# Part - 5 : Adding an Operating Cost & Write, View, and Load Data with a JSON
# ----------------------------------------------
# to a Renewable Generator
RenewableGenerationCost(; variable = CostCurve(; value_curve = LinearCurve(22.0)))

# A Thermal Generator
heat_rate_curve = PiecewisePointCurve([(100.0, 7.0), (200.0, 9.0)])
fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = 20.0)
cost = ThermalGenerationCost(;
    variable = fuel_curve,
    fixed = 6.0,
    start_up = 2000.0,
    shut_down = 1000.0,
)

sys = build_system(PSISystems, "c_sys5_pjm")
folder = mkdir("mysystems");
path = joinpath(folder, "system.json")
to_json(sys, path)

# ----------------------------------------------
# Part - 6 : Type Structure
# ----------------------------------------------
using PowerSystems 
import TypeTree: tt 
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); 
include(joinpath(docs_dir, "docs_utils.jl")); 
print_struct(ACBus) 

using PowerSystems 
import TypeTree: tt 
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); 
include(joinpath(docs_dir, "docs_utils.jl")); 
print(join(tt(TimeSeriesData), "")) 