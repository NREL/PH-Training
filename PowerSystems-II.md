# Session 4 : Sienna System Generation Training Script

This script demonstrates how to use the PowerSystemsCaseBuilder.jl package and provides a step-by-step guide to explore and build power system models.

## Introduction

In this script, we will utilize the PowerSystemsCaseBuilder.jl package, which houses a curated set of test systems. These test systems serve two primary purposes:

1. They assist the Sienna development team in testing new features.
2. They provide users with access to these test systems to facilitate their journey of learning and exploring Sienna.

## Step 1: Show All Systems for All Categories

To begin, we can list all the available test systems using the `show_systems()` function.

```julia
using PowerSystemCaseBuilder
show_systems()
```

## Step 2: Show All Categories

Next, let's explore the various categories available for these test systems.

```julia
using PowerSystemCaseBuilder
show_categories()
```

## Step 3: Show All Systems for One Category

Now, we can delve deeper into a specific category, such as `PSISystems`, to see the systems it contains.

```julia
using PowerSystemCaseBuilder
show_systems(PSISystems)
```

## Step 4: Build a System

Let's proceed by building a specific system from the available test systems. When doing so, two crucial arguments to consider are:

1. `time_series_directory`: While not required for local machine usage, it's necessary when running on NREL's HPC systems (Eagle or Kestrel). Users should pass `time_series_directory="/tmp/scratch"` as an argument.

2. `time_series_read_only`: This option loads the system in read-only mode, which can be helpful when dealing with large datasets. If you wish to edit time series information, do not use this option.

Here, we build two systems as examples:

1. The first system is the RTS Day-ahead system, which contains hourly time series data.

```julia
sys_da = PSB.build_system(PSISystems, "modified_RTS_GMLC_DA_sys";
                       time_series_directory="/tmp/scratch")
```

2. The second system is the RTS Real-time system, featuring 5-minute time series data.

```julia
sys_rt = PSB.build_system(PSISystems, "modified_RTS_GMLC_RT_sys";
                       time_series_directory="/tmp/scratch")
```

## Step 5: Save the System to JSON

Finally, we can save the system data to a JSON file for further analysis.

```julia
PSY.to_json(sys_da, "data/RTS_GMLC_DA.json")
PSY.to_json(sys_rt, "data/RTS_GMLC_RT.json")
```

This script provides a foundation for working with Sienna's power system models, exploring available test systems, and building custom models for analysis and simulation.
---

```markdown
# Tutorial: Building Sienna System Objects using PowerSystems.jl

---

## Introduction

In this tutorial, we will use **PowerSystems.jl**, **PowerSimulations.jl**, and **PowerSystemCaseBuilder.jl** to demonstrate how to build Sienna system objects. The tutorial leverages the curated Power Systems Test Data, which provides test systems useful for:
1. Assisting the Sienna development team in testing new features.
2. Offering users a starting point for understanding and exploring Sienna.

---

## Dependencies

To begin, make sure the necessary packages are loaded:

```julia
using PowerSystems
using PowerSimulations
using PowerSystemCaseBuilder

const PSB = PowerSystemCaseBuilder
const PSY = PowerSystems
```

---

## Accessing Test Data

The **PowerSystemCaseBuilder.jl** library includes several example datasets in different formats (e.g., PSSE RAW, Matpower, tabular CSV). These datasets allow us to build power system objects for further exploration.

### Listing Available RAW Files

```julia
readdir(joinpath(PSB.DATA_DIR, "psse_raw"))
```

### Copying Test Data to Local Directory

We will copy some essential files for demonstration purposes:

```julia
# Copy the PSSE RAW file for RTS-GMLC.
cp(joinpath(PSB.DATA_DIR, "psse_raw", "RTS-GMLC.RAW"), "data/RTS-GMLC.RAW")

# Copy the Matpower RTS-GMLC file.
cp(joinpath(PSB.DATA_DIR, "matpower", "RTS_GMLC.m"), "data/RTS_GMLC.m")

# Copy the entire RTS-GMLC data directory.
RTS_GMLC_DIR = joinpath(PSB.DATA_DIR, "RTS_GMLC")
cp(RTS_GMLC_DIR, "data/RTS_GMLC")
```

---

## Parsing Files into Sienna System Objects

We can now parse the copied files using `PowerSystems.jl` to create Sienna system objects.

### Example 1: Parsing a PSSE RAW File

PSSE files store network-related information. Devices will be initially parsed as `ThermalStandard` types, but they can later be converted to other generator types. The parser supports PSSE RAW formats up to version 33.

```julia
sys_psse = System("./data/RTS-GMLC.RAW")
```

### Example 2: Parsing a Matpower .m File

Matpower files contain comprehensive data, which allows for constructing a complete PCM system in a single step.

```julia
sys_matpower = System("./data/RTS_GMLC.m")
```

### Example 3: Parsing Tabular Data Format

In this format, CSV files are used to store data for each infrastructure type (e.g., `bus.csv`, `branch.csv`). Time series data can also be parsed using pointers and metadata files, providing flexibility in representation and storage.

```julia
rawsys = PSY.PowerSystemTableData(
    RTS_GMLC_DIR,
    100.0,  # Base power
    joinpath(RTS_GMLC_DIR, "user_descriptors.yaml");
    timeseries_metadata_file = joinpath(RTS_GMLC_DIR, "timeseries_pointers.json"),
    generator_mapping_file = joinpath(RTS_GMLC_DIR, "generator_mapping.yaml")
)

# Create the system object with a 1-hour time series resolution.
sys = PSY.System(
    rawsys; 
    time_series_resolution = Dates.Hour(1), 
    sys_kwargs...
)

# Transform the time series data to 24-hour periods.
PSY.transform_single_time_series!(sys, 24, Dates.Hour(24))
```

---

## Summary

This tutorial demonstrates how to build Sienna system objects from various file formats, including PSSE RAW, Matpower `.m`, and tabular CSV formats. The ability to parse different data formats enables users to easily explore and analyze power systems using **PowerSystems.jl**.

### Key Steps Recap:
1. Access system data files.
2. Copy relevant files to a working directory.
3. Parse the files to create system objects in Julia.
4. Utilize time series transformations for further analysis.

---

## Example Usage Script

```julia
using PowerSystems
using PowerSimulations
using PowerSystemCaseBuilder

const PSB = PowerSystemCaseBuilder
const PSY = PowerSystems

# Copy PSSE and Matpower files to local data directory.
cp(joinpath(PSB.DATA_DIR, "psse_raw", "RTS-GMLC.RAW"), "data/RTS-GMLC.RAW")
cp(joinpath(PSB.DATA_DIR, "matpower", "RTS_GMLC.m"), "data/RTS_GMLC.m")

# Parse PSSE RAW file.
sys_psse = System("./data/RTS-GMLC.RAW")

# Parse Matpower .m file.
sys_matpower = System("./data/RTS_GMLC.m")

# Parse tabular data format.
RTS_GMLC_DIR = joinpath(PSB.DATA_DIR, "RTS_GMLC")
rawsys = PSY.PowerSystemTableData(
    RTS_GMLC_DIR,
    100.0,
    joinpath(RTS_GMLC_DIR, "user_descriptors.yaml");
    timeseries_metadata_file = joinpath(RTS_GMLC_DIR, "timeseries_pointers.json"),
    generator_mapping_file = joinpath(RTS_GMLC_DIR, "generator_mapping.yaml")
)
sys = PSY.System(rawsys; time_series_resolution = Dates.Hour(1))
PSY.transform_single_time_series!(sys, 24, Dates.Hour(24))

println("Sienna system objects successfully created!")
```

---
# Sienna System Modification Training Script

This script demonstrates how to manipute the data in a System and provides a step-by-step guide to exploring different functionality provide in PowerSystmes.jl package.

## Loading Sienna Packages and dependencies 
```julia
using PowerSimulations
using PowerSystems
const PSI = PowerSimulations
const PSY = PowerSystems
using DataFrames
using TimeSeries
using CSV
using Dates
```
## Loading system
```julia
sys = PSY.System("data/RTS_GMLC_DA.json");
```

## Transform Static Time Series into Forecasts

In many modeling workflows, it's common to transform data generated from a realization and stored in a single column into deterministic forecasts. This transformation accounts for the effects of lookahead. However, it can lead to large data duplications in overlapping windows between forecasts. PowerSystems provides a method to transform SingleTimeSeries data into Deterministic forecasts without duplicating any data. The resulting object behaves exactly like a Deterministic. Instead of storing windows at each initial time, it provides a view into the existing data at incrementing offsets.

```julia
transform_single_time_series!(sys, 24, Hour(24))
```

## Accessing Components

You can access all the components of a particular type. Note that the return type of `get_components` is a `FlattenIteratorWrapper`, so you should call `collect` to get an `Array`.

```julia
get_components(Bus, sys) |> collect
```

`get_components` also works on abstract types:

```julia
get_components(Branch, sys) |> collect
```

## Querying a Component by Name

You can query a component by name:

```julia
get_component(ThermalGen, sys, "generator-24555-S3")
```

## Accessing Fields Within a Component

To access fields within a component, it's highly recommended that users avoid using the `.` to access fields since we make no guarantees on the stability of field names and locations. We do, however, promise to keep the accessor functions stable.

```julia
bus1 = get_component(Bus, sys, "nodeA")
get_name(bus1)
get_magnitude(bus1)
```

## Removing a Specific Component

You can remove a specific component:

```julia
remove_component!(sys, get_component(ThermalGen, sys, "generator-24555-S3"))
remove_component!(ThermalGen, sys, "generator-24555-S3")
```

## Removing All Hydro Components

Remove all hydro components from the system:

```julia
remove_components!(HydroDispatch, sys)
```

## Setting Components Offline

To exclude components from the simulation without deleting them permanently, you can set them as unavailable. For example, here's how to set thermal generators with a maximum active power limit of 0.0 as unavailable:

```julia
for gen in PSY.get_components(x -> PSY.get_active_power_limits(x).max == 0.0, PSY.ThermalGen, sys)
    PSY.set_available!(gen, false)
end
```

**Advanced Query Example**

In this example, we demonstrate how to perform advanced queries by passing a filter function to `get_components`. This feature is a powerful tool for making bulk changes in the system, which can be especially handy for homework assignments.

**Querying Combined Cycle Thermal Generators**

1. First, let's query all Combined Cycle thermal generators in the system:
   
```julia
gen = PSY.get_components(x -> PSY.get_prime_mover(x) == PSY.PrimeMovers.CC, PSY.ThermalGen, sys) |> first`
```
**Querying Combined Cycle Thermal Generators in Region/Area 1**

2. Next, we'll narrow it down and query all Combined Cycle thermal generators from Region/Area 1 in the system:

```julia
gen = PSY.get_components(x -> PSY.get_prime_mover(x) == PSY.PrimeMovers.CC && PSY.get_area(PSY.get_bus(x)) == "1", PSY.ThermalGen, sys) |> first`
```
**Querying Solar PV Plants**

3. Suppose you want to query all solar PV plants from the system with a nameplate capacity between 50 MW and 150 MW. First, make sure the unit settings of the system are set to Natural units using:

```julia
PSY.set_units_base_system!(sys, PSY.UnitSystem.NATURAL_UNITS)`
```
   Then, you can perform the query:

```julia
gens = PSY.get_components(x -> PSY.get_prime_mover(x) == PSY.PrimeMovers.PVe && PSY.get_max_active_power(x) >= 50.0 && PSY.get_max_active_power(x) <= 150.0, PSY.RenewableDispatch, sys) |> collect`
```
**Querying Wind Plants**

4. Now, let's perform a similar exercise, but this time for wind plants with a nameplate capacity above 100 MW:

```julia
gens = PSY.get_components(x -> PSY.get_prime_mover(x) == PSY.PrimeMovers.WT && PSY.get_max_active_power(x) >= 100.0, PSY.RenewableDispatch, sys) |> collect
```

**Updating Device Parameters**

Here, we provide an example function to change the ramp rate of each thermal device in the system. You can easily modify this function by passing a filter function to apply it to specific groups of thermal generators.

```julia
function update_thermal_ramp_rates!(sys)
    for th in get_components(ThermalGen, sys)
        pmax = get_active_power_limits(th).max
        set_ramp_limits!(th, (up = (pmax*0.2)/60, down = (pmax*0.2)/60)) # Ramp rate is expected to be in MW/min
    end
    return
end

update_thermal_ramp_rates!(sys)
```

### Copying a Renewable Dispatch Component

This code demonstrates how to create a copy of a `RenewableDispatch` component, customize it, and add it to the power system.

```julia
## Create a copy of a Renewable Dispatch component
function copy_component(sys::PSY.System, re::PSY.RenewableDispatch, bus_name, name)
    # Get the bus associated with the specified name
    bus = PSY.get_component(Bus, sys, bus_name)
    
    # Create a new Renewable Dispatch component as a copy
    device = PSY.RenewableDispatch(
        name=name,               # Set the name for the new component
        available=true,          # Mark the component as available
        bus=bus,                 # Assign the bus to the component
        active_power=re.active_power,                # Copy active power from the original component
        reactive_power=re.reactive_power,            # Copy reactive power from the original component
        rating=re.rating,                          # Copy the rating from the original component
        prime_mover=re.prime_mover,                # Copy the prime mover from the original component
        reactive_power_limits=re.reactive_power_limits,  # Copy reactive power limits
        power_factor=re.power_factor,              # Copy power factor
        operation_cost=re.operation_cost,          # Copy operation cost
        base_power=re.base_power                  # Copy base power
    )
    
    return device  # Return the newly created component
end

## Creating a copy of the device to add new capacity to the system.
pv = first(get_components(x-> x.prime_mover == PSY.PrimeMovers.PVe, RenewableGen, sys,))
device = copy_component(sys, pv, pv.bus, "new_PV")  # Create a new PV component as a copy

## Adding the new component to the system
add_component!(sys, device)  # Add the new PV component to the system

## Copying over the time series data from the original device to the new device.
copy_time_series!(device, pv)  # Copy time series data from the original PV device to the new PV device
```

## Adding a New Battery Component
This code demonstrates how to create a new battery component, customize its parameters, and add it to the power system.

```julia
### Adding New Components
function _build_battery(::Type{T}, bus::PSY.Bus, name::String, energy_capacity, rating, efficiency) where {T<:PSY.Storage}
    # Create a new storage device of the specified type
    device = T(
        name=name,                         # Set the name for the new component
        available=true,                    # Mark the component as available
        bus=bus,                           # Assign the bus to the component
        prime_mover=PSY.PrimeMovers.BA,    # Set the prime mover to Battery
        initial_energy=energy_capacity / 2,  # Set initial energy level
        state_of_charge_limits=(min=energy_capacity * 0.1, max=energy_capacity),  # Set state of charge limits
        rating=rating,                     # Set the rating
        active_power=rating,               # Set active power equal to rating
        input_active_power_limits=(min=0.0, max=rating),  # Set input active power limits
        output_active_power_limits=(min=0.0, max=rating),  # Set output active power limits
        efficiency=(in=efficiency, out=1.0),  # Set efficiency
        reactive_power=0.0,                # Set reactive power
        reactive_power_limits=nothing,      # No reactive power limits
        base_power=100.0                   # Set base power
    )
    
    return device  # Return the newly created component
end

### Creating a copy of the device to add new capacity to the system.
bus = first(get_components(x-> x.prime_mover == PSY.PrimeMovers.PVe, RenewableGen, sys,))
device = _build_battery(GenericBattery, bus, "new_battery", 10.0, 2.5, 0.8)  # Create a new battery component

add_component!(sys, device)  # Add the new battery component to the system
```
## Converting Thermal Devices

### Converting to `ThermalMultiStart`

To convert thermal devices from `ThermalStandard` to `ThermalMultiStart`, use the `PSY.convert_component!` function. This is often used to set devices as "must-run" units in the Unit Commitment (UC) problem.

```julia
function PSY.convert_component!(
    thtype::Type{PSY.ThermalMultiStart},
    th::ThermalStandard,
    sys::System;
    kwargs...
)
```

- `thtype::Type{PSY.ThermalMultiStart}` specifies the target type (`ThermalMultiStart`).
- `th::ThermalStandard` represents the thermal device you want to convert.
- `sys::System` is your power system model.

### Converting Nuclear Devices

To convert all nuclear devices in your system, use the `convert_must_run_units!` function. This ensures that nuclear units are set as "must-run" units in your UC problem.

```julia
function convert_must_run_units!(sys)
```

## Adding Reserves

### Adding Reserves to the System

The `add_reserves` function allows you to add reserve capacity to your system, which is essential for maintaining grid reliability.

```julia
function add_reserves(sys; reserve_frac=0.1)
```

- `sys::System` is your power system model.
- `reserve_frac` (default 0.1) determines the reserve capacity as a fraction of the maximum load.

### Updating Contributing Devices

To ensure that the necessary storage devices are eligible for providing reserves, use the `update_contributing_devices!` function.

```julia
function update_contributing_devices!(sys, service)
```

- `sys` is your power system model.
- `service` is the reserve service to which contributing devices should be assigned.

### Example Function: Generating Timestamps

Here's a simple Julia function, `get_day_ahead_timestamps`, for generating timestamps, which can be helpful for adding time series data:

```julia
get_day_ahead_timestamps(sim_year) = collect(DateTime("$(sim_year)-01-01T00:00:00"):Hour(1):DateTime("$(sim_year)-12-31T23:00:00"))
```

## Modifying Time Series Data

### Updating Wind Generation Time Series

The `update_wind_timeseries!` function allows you to modify the time series data for wind generation. In this example, we reduce wind generation by 5%, but you can adapt this workflow for other adjustments.

```julia
function update_wind_timeseries!(sys, file_path_max, file_path_min)
```

- `sys` is your power system model.
- `file_path_max` and `file_path_min` specify the file paths for maximum and minimum wind generation data.

## Saving the Modified System

After making these modifications, save your updated system to a JSON file for further analysis or simulations:

```julia
PSY.to_json("data/RTS_GMLC_DA_test_modifications.json")
```