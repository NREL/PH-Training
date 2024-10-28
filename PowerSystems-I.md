# Welcome to PowerSystems.jl

## About

`PowerSystems.jl` is part of the National Renewable Energy Laboratory's
[Sienna ecosystem](https://www.nrel.gov/analysis/sienna.html), an open source framework for
scheduling problems and dynamic simulations for power systems. The Sienna ecosystem can be
[found on github](https://github.com/NREL-Sienna/Sienna). It contains three applications:

  - [Sienna\Data](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennadata) enables
    efficient data input, analysis, and transformation
  - [Sienna\Ops](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennaops) enables
    enables system scheduling simulations by formulating and solving optimization problems
  - [Sienna\Dyn](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennadyn) enables
    system transient analysis including small signal stability and full system dynamic
    simulations

Each application uses multiple packages in the [`Julia`](http://www.julialang.org)
programming language.

`PowerSystems.jl` is the foundation of Sienna\Data, and it is used with all three
applications. It provides a rigorous
data model using Julia structures to enable power systems modeling. `PowerSystems.jl` is
agnostic to a specific mathematical model and can be used for many model categories.

`PowerSystems.jl` provides tools to prepare and process data useful
for electric energy systems modeling. This package serves two purposes:

 1. It facilitates the development and open sharing of large data sets for Power Systems modeling
 2. It provides a data model that imposes discipline on model specification, addressing the challenge of design and terminology choices when sharing code and data.

The main features include:

  - Comprehensive and extensible library of data structures for electric systems modeling.
  - Large scale data set development tools based on common text based data formats
    (PSS/e `.raw` and `.dyr`, and `MATPOWER`) and configurable tabular data (e.g. CSV)
    parsing capabilities.
  - Optimized container for component data and time series supporting serialization to
    portable file formats and configurable validation routines.

## How To Use This Documentation

There are five main sections containing different information:

  - **Tutorials** - Detailed walk-throughs to help you *learn* how to use
    `PowerSystems.jl`
  - **How to...** - Directions to help *guide* your work for a particular task
  - **Explanation** - Additional details and background information to help you *understand*
    `PowerSystems.jl`, its structure, and how it works behind the scenes
  - **Reference** - Technical references and API for a quick *look-up* during your work
  - **Model Library** - Technical references of the data types and their functions that
    `PowerSystems.jl` uses to model power system components

`PowerSystems.jl` strives to follow the [Diataxis](https://diataxis.fr/) documentation
framework.

## Getting Started

If you are new to `PowerSystems.jl`, here's how we suggest getting started:

 1. [Install](@ref install)

 2. Work through the introductory tutorial: [Create and Explore a Power `System`](@ref) to
    familiarize yourself with how `PowerSystems.jl` works
 3. Work through the other basic tutorials based on your interests
    
      + See [Working with Time Series Data](@ref tutorial_time_series) if you will be doing
        production cost modeling or working with time series
      + See [Adding Data for Dynamic Simulations](@ref)
        if you are interested in [dynamic](@ref D) simulations
 4. Then, see the how-to's on parsing [Matpower](@ref pm_data) or [PSS/e files](@ref dyr_data) or
    [CSV files](@ref table_data) to begin loading your own data into `PowerSystems.jl`

## Install PowerSystems.jl

PowerSystems.jl is a command line tool written in the Julia programming language. To install:

### Step 1: Install Julia

[Follow the instructions here](https://julialang.org/downloads/)

### Step 2: Open Julia

Start the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) from a command line:
```
$ julia
```

You should see the Julia REPL start up, which looks something like this:
```
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.4 (2024-06-04)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```
If not, go back to check the Julia installation steps.


### Step 3: Install `PowerSystems.jl`

Install the latest stable release of `PowerSystems.jl` using the
[Julia package manager](https://docs.julialang.org/en/v1/stdlib/Pkg/#Pkg) with:

```julia
] add PowerSystems
```
Once you type `]`, you will see the prompt change color as it activates the Julia package
manager. This command may take a few minutes to download the packages and compile them.

Press the delete or backspace key to return to the REPL. 

Install is complete!

!!! note "Alternate"
    To use the current development version instead, "checkout" the main branch of this package with:

    ```julia
    ] add PowerSystems#main
    ```

!!! note
    `PowerSystems.jl` uses [`InfrastructureSystems.jl`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/)
    as a utility library. Many methods are re-exported from `InfrastructureSystems.jl`.
    For most users there is no need to import `InfrastructureSystems.jl`.

# Load a `system` from `PowerSystemCaseBuilder`

## Introduction

[PowerSystemCaseBuilder.jl](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl) provides a utility to manage a library of `System`s. The package has utilities to list the available system data and to create instances of each system. By keeping track of which systems have been constructed locally, it makes the re-instantiation of systems efficient by utilizing the serialization features and avoiding the parsing process for systems that have been previously constructed.

## Dependencies

```@repl psb
using PowerSystemCaseBuilder
```

## List all systems in library

```@repl psb
show_systems()
```

## Systems can be listed by category

The available categories can be displayed with:

```@repl psb
show_categories()
```

## Create a `System`

The first time this is run, it will parse csv data. Subsequent executions will rely on serialized data and will execute much faster since the employ deserialization

```@repl psb
sys = build_system(PSITestSystems, "c_sys5_uc")
```

# Parsing MATPOWER or PSS/e Files

The following code will create a System from a MATPOWER .m or PSS/e .raw file:

```@repl m_system
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data")
sys = System(joinpath(file_dir, "case5.m"))
```

This parsing code was copied with permission from
[`PowerModels.jl`](https://github.com/lanl-ansi/PowerModels.jl).


# Parse Tabular Data from .csv Files

!!! warning
    
    This parser will be deprecated sometime in the fall of 2024. `PowerSystems.jl` will be
    moving to a database solution for handling data. There are plans to eventually include
    utility functions to translate from .csv files to the database, but there will probably
    be a gap in support. **Users are recommended to write their own custom Julia code to
    import data from their unique data formats, rather than relying on this parsing
    code.**

This parser, called the tabular data parser, is a custom format that allows users to define
power system component data by category and column with custom names, types, and units.

## Categories

Components for each category must be defined in their own CSV file. The
following categories are currently supported:

  - branch.csv

  - bus.csv (required)
    
      + columns specifying `area` and `zone` will create a corresponding set of `Area` and `LoadZone` objects.
      + columns specifying `max_active_power` or `max_reactive_power` will create `PowerLoad` objects when nonzero values are encountered and will contribute to the `peak_active_power` and `peak_reactive_power` values for the
        corresponding `LoadZone` object.
  - dc_branch.csv
  - gen.csv
  - load.csv
  - reserves.csv
  - storage.csv

These must reside in the directory passed when constructing PowerSystemTableData.

## Customization

The tabular data parser in `PowerSystems.jl` can be customized to read a variety of
datasets by configuring:

  - [which type of generator (`<:Generator`) to create based on the fuel and prime mover specifications](@ref csv_genmap)
  - [property names](@ref csv_columns), [units](@ref csv_units), and [per units conversions](@ref csv_per_unit) in *.csv files

Here is an example of how to construct a System with all customizations listed in this section:

```julia
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
```

Examples configuration files can be found in the [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/) repo:

  - [user_descriptors.yaml](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml)
  - [generator_mapping.yaml](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/generator_mapping.yaml)

## CSV Data Configurations

### Custom construction of generators

`PowerSystems` supports custom construction of subtypes of the abstract type Generator based
on `fuel` and `type`. The parsing code detects these fields in the raw data and then
constructs the concrete type listed in the passed generator mapping file. The default file
is `src/parsers/generator_mapping.yaml`. You can override this behavior by specifying your
own file when constructing `PowerSystemTableData`.

### Column names

`PowerSystems` provides am input mapping capability that allows you to keep your own
column names.

For example, when parsing raw data for a generator the code expects a column
called `name`. If the raw data instead defines that column as `GEN UID` then
you can change the `custom_name` field under the `generator` category to
`GEN UID` in your YAML file.

To enable the parsing of a custom set of csv files, you can generate a configuration
file (such as `user_descriptors.yaml`) from the defaults, which are stored
in `src/descriptors/power_system_inputs.json`.

```python
python ./bin/generate_config_file.py ./user_descriptors.yaml
```

Next, edit this file with your customizations.

Note that the user-specific customizations are stored in YAML rather than JSON
to allow for easier editing. The next few sections describe changes you can
make to this YAML file.  Do not edit the default JSON file.

## Per-unit conversion

For more info on the per-unit conventions in `PowerSystems.jl`, refer to the [per-unit
section of the system documentation](@ref per_unit).

`PowerSystems` defines whether it expects a column value to be per-unit system base,
per-unit device base, or natural units in `power_system_inputs.json`. If it expects a
per-unit convention that differs from your values then you can set the `unit_system` in
`user_descriptors.yaml` and `PowerSystems` will automatically convert the values. For
example, if you have a `max_active_power` value stored in natural units (MW), but
`power_system_inputs.json` specifies `unit_system: device_base`, you can enter
`unit_system: natural_units` in `user_descriptors.yaml` and `PowerSystems` will divide
the value by the value of the corresponding entry in the column identified by the
`base_reference` field in `power_system_inputs.json`. You can also override the
`base_reference` setting by adding `base_reference: My Column` to make device base
per-unit conversion by dividing the value by the entry in `My Column`. System base
per-unit conversions always divide the value by the system `base_power` value
instantiated when constructing a `System`.

### Unit conversions

`PowerSystems` provides a limited set of unit conversions. For example, if
`power_system_inputs.json` indicates that a value's unit is degrees but
your values are in radians then you can set `unit: radian` in
your YAML file. Other valid `unit` entries include `GW`, `GWh`, `MW`, `MWh`, `kW`,
and `kWh`.

## Extending the Tabular Data Parser

This section describes how developers should read columns from raw data files, and
assumes you are familiar with the sections above.

The main point is that you should not read individual hard-coded column names from
DataFrames. The parsing code includes mapping functionality that allows you to
use PowerSystems-standard names while letting the users define their own custom
names.

### Procedure

 1. Add an entry to the array of parameters for your category in
    `src/descriptors/power_system_inputs.json` according to the following:
    
     1. Use `snake_case` for the name field.
     2. The fields `name` and `description` are required.
     3. Try to use a name that is generic and not specific to one dataset.
     4. It is recommended that you define `unit`.
     5. If PowerSystems expects the value to be per-unit then you must specify
        `system_per_unit=true`.

 2. PowerSystems has two commonly-used datasets with customized user config
    files:
    [PowerSystemsTestData](https://github.com/NREL/PowerSystemsTestData/blob/main/RTS_GMLC/user_descriptors.yaml)
    and
    [RTS_GMLC](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml).
    Update both of these files and submit pull requests.
 3. Parse the raw data like in this example:

```julia
function demo_bus_csv_parser!(data::PowerSystemTableData)
    for bus in iterate_rows(data, BUS::InputCategory)
        @show bus.name, bus.max_active_power, bus.max_reactive_power
    end
end
```

`iterate_rows` returns a NamedTuple where each `name` defined in
`src/descriptors/power_system_inputs.json` is a field.


# Parse Time Series Data from .csv's

This example shows how to parse time series data from .csv files to add to a `System`.
For example, a `System` created by [parsing a MATPOWER file](@ref pm_data) doesn't contain
any time series data, so a user may want to add time series to be able to run a production
cost model.

```@setup forecasts
using PowerSystems
using JSON3

file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data"); #hide
sys = System(joinpath(file_dir, "case5_re.m"));
```

Let's use a predefined 5-bus [`System`](@ref) with some renewable generators and loads that
we want to add time-series data to:

```@repl forecasts
sys
```

## Define pointers to time series files

`PowerSystems` requires a metadata file that maps components to their time series
data in order to be able to automatically construct time_series from .csv data
files.

For example, if we want to add a bunch of time series files, say one for each load and one
for each renewable generator, we need to define *pointers* to each time series .csv file
with the following fields:

  - `simulation`:  User description of simulation
  - `resolution`:  Resolution of time series in seconds
  - `module`:  Module that defines the abstract type of the component
  - `category`:  Type of component. Must map to abstract types defined by the "module"
    entry (Bus, ElectricLoad, Generator, LoadZone, Reserve)
  - `component_name`:  Name of component
  - `name`:  User-defined name for the time series data.
  - `normalization_factor`:  Controls normalization of the data. Use 1.0 for
    pre-normalized data. Use 'Max' to divide the time series by the max value in the
    column. Use any float for a custom scaling factor.
  - `scaling_factor_multiplier_module`:  Module that defines the accessor function for the
    scaling factor
  - `scaling_factor_multiplier`:  Accessor function of the scaling factor
  - `data_file`:  Path to the time series data file

Notes:

  - The `module`, `category`, and `component_name` entries must be valid arguments to retrieve
    a component using `get_component(${module}.${category}, sys, $name)`.
  - The `scaling_factor_multiplier_module` and the `scaling_factor_multiplier` entries must
    be sufficient to return the scaling factor data using
    `${scaling_factor_multiplier_module}.${scaling_factor_multiplier}(component)`.

`PowerSystems` supports this metadata in either CSV or JSON formats.

In this example, we will use the JSON format. The example file can be found
[here](https://github.com/NREL-Sienna/PowerSystemsTestData/blob/master/5-Bus/5bus_ts/timeseries_pointers_da.json),
and this is what its pointers look like in the required format:

```@repl forecasts
using PowerSystemCaseBuilder #hide
DATA_DIR = PowerSystemCaseBuilder.DATA_DIR #hide
FORECASTS_DIR = joinpath(DATA_DIR, "5-Bus", "5bus_ts"); #hide
fname = joinpath(FORECASTS_DIR, "timeseries_pointers_da.json"); # hide
open(fname, "r") do f # hide
    JSON3.@pretty JSON3.read(f) # hide
end #hide
```

## Read and assign time series to `System` using these parameters.

```@repl forecasts
fname = joinpath(FORECASTS_DIR, "timeseries_pointers_da.json")
add_time_series!(sys, fname)
```

You can print the `System` to see a new table summarizing the time series data that has been
added:

```@repl forecasts
sys
```


# Add a Component in Natural Units

```@setup add_in_nu
using PowerSystems; #hide
using PowerSystemCaseBuilder #hide
system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"); #hide
```

`PowerSystems.jl` has [three per-unitization options](@ref per_unit) for getting, setting
and displaying data.

Currently, only one of these options -- `"DEVICE_BASE"` -- is supported when using a
constructor function define a component. You can see
[an example of the default capabilities using `"DEVICE_BASE"` here](@ref "Adding Loads and Generators").

We hope to add capability to define components in
`"NATURAL_UNITS"` with constructors in the future, but for now, below is a workaround
for users who prefer to define data using `"NATURAL_UNITS"` (e.g., MW, MVA, MVAR, or MW/min):

### Step 1: Set Units Base

Set your (previously-defined) `System`'s units base to `"NATURAL_UNITS"`:

```@repl add_in_nu
set_units_base_system!(system, "NATURAL_UNITS")
```

Now, the "setter" functions have been switched to define data using natural units (MW, MVA,
etc.), taking care of the necessary data conversions behind the scenes.

### Step 2: Define Empty Component

Define an empty component with `0.0` or `nothing` for all the power-related fields except
`base_power`, which is always in MVA.

For example:

```@repl add_in_nu
gas1 = ThermalStandard(;
    name = "gas1",
    available = true,
    status = true,
    bus = get_component(ACBus, system, "Cobb"), # Attach to a previously-defined bus named Cobb
    active_power = 0.0,
    reactive_power = 0.0,
    rating = 0.0,
    active_power_limits = (min = 0.0, max = 0.0),
    reactive_power_limits = nothing,
    ramp_limits = nothing,
    operation_cost = ThermalGenerationCost(nothing),
    base_power = 30.0, # MVA
    time_limits = (up = 8.0, down = 8.0), # Hours, unaffected by per-unitization
    must_run = false,
    prime_mover_type = PrimeMovers.CC,
    fuel = ThermalFuels.NATURAL_GAS,
);
```

### Step 3: Attach the Component

Attach the component to your `System`:

```@repl add_in_nu
add_component!(system, gas1)
```

### Step 4: Add Data with "setter" Functions

Use individual "setter" functions to set each the value of each numeric field in natural
units:

```@repl add_in_nu
set_rating!(gas1, 30.0) #MVA
set_active_power_limits!(gas1, (min = 6.0, max = 30.0)) # MW
set_reactive_power_limits!(gas1, (min = 6.0, max = 30.0)) # MVAR
set_ramp_limits!(gas1, (up = 6.0, down = 6.0)) #MW/min
```

Notice the return values are divided by the `base_power` of 30 MW, showing the setters have
done the per-unit conversion into `"DEVICE_BASE"` behind the scenes.

!!! tip
    
    Steps 2-4 can be called within a `for` loop to define many components at once (or step 3
    can be replaced with [`add_components!`](@ref) to add all components at once).


# Get the buses in a System

```@setup get_buses
using PowerSystems; #hide
using PowerSystemCaseBuilder #hide
system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"); #hide
```

You can access all the buses in a `System` to view or manipulate their data using two
key functions: `get_components` or `get_buses`.

#### Option 1a: Get an iterator for all the buses

Use [`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
to get an iterator of all the AC buses in an existing [`system`](@ref System):

```@repl get_buses
bus_iter = get_components(ACBus, system)
```

The iterator avoids unnecessary memory allocations if there are many buses, and it can be
used to view or update the bus data.
For example, we can set the base voltage of all buses to 330 kV:

```@repl get_buses
for b in bus_iter
    set_base_voltage!(b, 330.0)
end
```

#### Option 1b: Get a vector of all the buses

Use `collect` to get a vector of the buses instead of an iterator, which could require a lot
of memory:

```@repl get_buses
buses = collect(get_components(ACBus, system))
```

#### Option 2a: Get the buses in an Area or LoadZone

Use [`get_buses`](@ref) to get a vector of buses when you know which [`Area`](@ref) or
[`LoadZone`](@ref) you are interested in.

First, we select an Area:

```@repl get_buses
show_components(Area, system) # See available Areas
area2 = get_component(Area, system, "2"); # Get Area named 2
```

Then call `get_buses` for that Area:

```@repl get_buses
area_buses = get_buses(system, area2)
```

#### Option 2b: Get buses by ID number

Finally, use [`get_buses`](@ref get_buses(sys::System, bus_numbers::Set{Int})) to get a
vector of buses by their ID numbers.

Example getting buses with ID numbers from 101 to 110:

```@repl get_buses
buses_by_ID = get_buses(system, Set(101:110))
```

!!! note
    
    You can combine this with Option 1 to first view all the bus numbers if needed:
    
    ```@repl get_buses
    get_number.(get_components(ACBus, system))
    ```


# Get the available generators in a System

```@setup get_gens
using PowerSystems; #hide
using PowerSystemCaseBuilder #hide
system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"); #hide
```

You can access use [`get_available_components`](@ref) or
[`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
to access all the available generators in an existing [`system`](@ref System).

#### Option 1a: Using `get_available_components` to get an iterator

Use [`get_available_components`](@ref) to get an iterator of all the available generators in
an existing [`system`](@ref System), which also prints a summary:

```@repl get_gens
gen_iter = get_available_components(Generator, system)
```

The iterator avoids unnecessary memory allocations if there are many generators, and it can
be used to view or update the generator data, such as seeing each of the names:

```@repl get_gens
get_name.(gen_iter)
```

!!! tip
    
    Above, we use the abstract supertype [`Generator`](@ref) to get all components that are
    subtypes of it. You can instead get all the components of a concrete type, such as:
    
    ```@repl get_gens
    gen_iter = get_available_components(RenewableDispatch, system)
    ```

#### Option 1b: Using `get_available_components` to get a vector

Use `collect` to get a vector of the generators instead of an iterator, which could require
a lot of memory:

```@repl get_gens
gens = collect(get_available_components(Generator, system));
```

#### Option 2: Using `get_components` to get an iterator

Alternatively, use [`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
with a filter to check for availability:

```@repl get_gens
gen_iter = get_components(get_available, Generator, system)
```

`collect` can also be used to turn this iterator into a vector.


# Adding an Operating Cost

This how-to guide covers the steps to select and add an operating cost to a component,
such as a generator, load, or energy storage system.

```@setup costcurve
using PowerSystems #hide
```

To begin, the user must make 2 or 3 decisions before defining the operating cost:

 1. Select an appropriate [`OperationalCost`](@ref) from the [`OperationalCost`](@ref)
    options. In general, each operating cost has parameters to define fixed and variable costs.
    To be able to define an `OperationalCost`, you must first select a curve to represent the
    variable cost(s).
    
     1. If you selected [`ThermalGenerationCost`](@ref) or [`HydroGenerationCost`](@ref),
        select either a [`FuelCurve`](@ref) or [`CostCurve`](@ref) to represent the variable
        cost, based on the units of the generator's data.
        
          * If you have data in terms of heat rate or water flow, use [`FuelCurve`](@ref).
          * If you have data in units of currency, such as \$/MWh, use [`CostCurve`](@ref).
            If you selected another `OperationalCost` type, the variable cost is represented
            as a `CostCurve`.

 2. Select a [`ValueCurve`](@ref) to represent the variable cost data by comparing the format
    of your variable cost data to the [Variable Cost Representations table](@ref curve_table)
    and the [`ValueCurve`](@ref) options.

Then, the user defines the cost by working backwards:

 1. Define the variable cost's `ValueCurve`
 2. Use the `ValueCurve` to define the selected `CostCurve` or `FuelCurve`
 3. Use the `CostCurve` or `FuelCurve` to define the `OperationalCost`

Let's look at a few examples.

## Example 1: A Renewable Generator

We have a renewable unit that produces at \$22/MWh.

Following the decision steps above:

 1. We select [`RenewableGenerationCost`](@ref) to represent this renewable generator.
 2. We select a [`LinearCurve`](@ref) to represent the \$22/MWh variable cost.

Following the implementation steps, we define `RenewableGenerationCost` by nesting the
definitions:

```@repl costcurve
RenewableGenerationCost(; variable = CostCurve(; value_curve = LinearCurve(22.0)))
```

## Example 2: A Thermal Generator

We have a thermal generating unit that has a heat rate of 7 GJ/MWh at 100 MW and 9 GJ/MWh at
200 MW, plus a fixed cost of \$6.0/hr, a start-up cost of \$2000, and a shut-down cost of
\$1000. Its fuel cost is \$20/GJ.

Following the decision steps above:

 1. We select [`ThermalGenerationCost`](@ref) to represent this thermal generator.
 2. We select [`FuelCurve`](@ref) because we have consumption in units of fuel (GJ/MWh)
    instead of currency.
 3. We select a [`PiecewisePointCurve`](@ref) to represent the piecewise linear heat rate
    curve.

This time, we'll define each step individually, beginning with the heat rate curve:

```@repl costcurve
heat_rate_curve = PiecewisePointCurve([(100.0, 7.0), (200.0, 9.0)])
```

Use the heat rate to define the fuel curve, including the cost of fuel:

```@repl costcurve
fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = 20.0)
```

Finally, define the full operating cost:

```@repl costcurve
cost = ThermalGenerationCost(;
    variable = fuel_curve,
    fixed = 6.0,
    start_up = 2000.0,
    shut_down = 1000.0,
)
```

This `OperationalCost` can be used when defining a component or added to an existing component using
`set_operation_cost!`.

# Write, View, and Load Data with a JSON

`PowerSystems.jl` provides functionality to serialize an entire [`System`](@ref) to a JSON
file and then deserialize it back to a `System`. The main benefit is that
deserializing is significantly faster than reconstructing the `System` from raw
data files.

The sections below show how to write data to a JSON, explore the data while it is in
JSON format, and load Data saved in a JSON back into `PowerSystems.jl`.

## Write data to a JSON

You can do this to save your own custom `System`, but we'll use an existing
dataset from
[`PowerSystemCaseBuilder.jl`](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl),
simply to illustrate the process.

First, load the dependencies and a `System` from `PowerSystemCaseBuilder`:

```@repl serialize_data
using PowerSystems
using PowerSystemCaseBuilder
sys = build_system(PSISystems, "c_sys5_pjm")
```

Set up your target path, for example in a "mysystems" subfolder:

```@repl serialize_data
folder = mkdir("mysystems");
path = joinpath(folder, "system.json")
```

Now write the system to JSON:

```@repl serialize_data
to_json(sys, path)
```

Notice in the `Info` statements that the serialization process stores 3 files:

 1. System data file (`*.json` file)
 2. Validation data file (`*.json` file)
 3. Time Series data file (`*.h5` file)

## Viewing `PowerSystems` Data in JSON Format

Some users prefer to view and filter the `PowerSystems.jl` data while it is in JSON format.
There are many tools available to browse JSON data.

Here is an example [GUI tool](http://jsonviewer.stack.hu) that is available
online in a browser.

The command line utility [jq](https://stedolan.github.io/jq/) offers even more
features. Below are some example commands, called from the command line within the
"mysystems" subfolder:

View the entire file pretty-printed:

```zsh
jq . system.json
```

View the `PowerSystems` component types:

```zsh
jq '.data.components | .[] | .__metadata__ | .type' system.json | sort | uniq
```

View specific components:

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard")' system.json
```

Get the count of a component type:

```zsh
# There is almost certainly a better way.
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard")' system.json | grep -c ThermalStandard
```

View specific component by name:

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard" and .name == "107_CC_1")' system.json
```

Filter on a field value:

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard" and .active_power > 2.3)' system.json
```

## Read the JSON file and create a new `System`

Finally, you can read the file back in, and verify the new system has the same data as above:

```@repl serialize_data
sys2 = System(path)
rm(folder; recursive = true); #hide
```

!!! tip
    
    PowerSystems generates UUIDs for the `System` and all components in order to have
    a way to uniquely identify objects. During deserialization it restores the same
    UUIDs.  If you will modify the `System` or components after deserialization then
    it is recommended that you set this flag to generate new UUIDs.
    
    ```julia
    system2 = System(path; assign_new_uuids = true)
    ```

# System

The `System` is the main container of components and the time series data references.
`PowerSystems.jl` uses a hybrid approach to data storage, where the component data and time
series references are stored in volatile memory while the actual time series data is stored
in an HDF5 file. This design loads into memory the portions of the data that are relevant
at time of the query, and so avoids overwhelming the memory resources.


## Accessing components stored in the `System`

`PowerSystems.jl` implements a wide variety of methods to search for components to
aid in data manipulation. Most of these use the [Type Structure](@ref type_structure) to
retrieve all components of a certain `Type`.

For example, the most common search function is [`get_components`](@ref), which
takes a desired device `Type` (concrete or abstract) and retrieves all components in that
category from the `System`. It also accepts filter functions for a more
refined search.

Given the potential size of the return,
`PowerSystems.jl` returns Julia iterators in order to avoid unnecessary memory allocations.
The container is optimized for iteration over abstract or concrete component
types as described by the [Type Structure](@ref type_structure).

## Accessing data stored in a component

__Using the "dot" access to get a parameter value from a component is actively discouraged, use "getter" functions instead__

Using code autogeneration, `PowerSystems.jl` implements accessor (or "getter") functions to
enable the retrieval of parameters defined in the component struct fields. Julia syntax enables
access to this data using the "dot" access (e.g. `component.field`), however
_this is actively discouraged_ for two reasons:

 1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
 2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit section](@ref per_unit) for more details)

# Type Structure

PowerSystems.jl provides a type hierarchy to contain power system data.

### Types in PowerSystems

In PowerSystems.jl, data that describes infrastructure components is held in `struct`s.
For example, an `ACBus` is a `struct` with the following parameters to describe a bus
on an AC network:

```@repl types
using PowerSystems #hide
import TypeTree: tt #hide
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); #hide
include(joinpath(docs_dir, "docs_utils.jl")); #hide
print_struct(ACBus) #hide
```

### Type Hierarchy

PowerSystems is intended to organize data by the behavior of the devices that
the data represents. A type hierarchy has been defined with several levels of
abstract types starting with `InfrastructureSystemsType`. There are a bunch of subtypes of
`InfrastructureSystemsType`, but the important ones to know about are:

  - `System`: overarching `struct` that collects all of the `Component`s

  - `Component`: includes all elements of power system data
    
      + `Topology`: includes non physical elements describing network connectivity
      + `Service`: includes descriptions of system requirements (other than energy balance)
      + `Device`: includes descriptions of all the physical devices in a power system
  - `InfrastructureSystems.DeviceParameter`: includes structs that hold data describing the
    dynamic, or economic capabilities of `Device`.
  - `TimeSeriesData`: Includes all time series types
    
      + `Forecast`: includes structs to define time series of forecasted data where multiple
        values can represent each time stamp
      + `StaticTimeSeries`: includes structs to define time series with a single value for each
        time stamp

The abstract hierarchy enables categorization of the devices by their operational
characteristics and modeling requirements.

For instance, generation is classified by the distinctive
data requirements for modeling in three categories: [`ThermalGen`](@ref), [`RenewableGen`](@ref),
and [`HydroGen`](@ref).

`PowerSystems.jl` has a category [`Topology`](@ref) of topological components
(e.g., [`ACBus`](@ref), [`Arc`](@ref)), separate from the physical components.

The hierarchy also includes components absent in standard data models, such as services.
The services category includes reserves, transfers and [`AGC`](@ref). The power of `PowerSystems.jl`
lies in providing the abstraction without an implicit mathematical representation of the component.

As a result of this design, developers can define model logic entirely based on abstract
types and create generic code to support modeling technologies that are not yet
implemented in the package.


# Per-unit Conventions

It is often useful to express power systems data in relative terms using per-unit conventions.
`PowerSystems.jl` supports the automatic conversion of data between three different unit systems:

 1. `"NATURAL_UNITS"`: The naturally defined units of each parameter (typically MW).
 2. `"SYSTEM_BASE"`: Parameter values are divided by the system `base_power`.
 3. `"DEVICE_BASE"`: Parameter values are divided by the device `base_power`.

`PowerSystems.jl` supports these unit systems because different power system tools and data
sets use different units systems by convention, such as:

  - Dynamics data is often defined in device base
  - Network data (e.g., reactance, resistance) is often defined in system base
  - Production cost modeling data is often gathered from variety of data sources,
    which are typically defined in natural units

These three unit bases allow easy conversion between unit systems.
This allows `PowerSystems.jl` users to input data in the formats they have available,
as well as view data in the unit system that is most intuitive to them.

You can get and set the unit system setting of a `System` with [`get_units_base`](@ref)
and [`set_units_base_system!`](@ref).

Conversion between unit systems does not change
the stored parameter values. Instead, unit system conversions are made when accessing
parameters using the [accessor functions](@ref dot_access), thus making it
imperative to utilize the accessor functions instead of the "dot" accessor methods to
ensure the return of the correct values. The units of the parameter values stored in each
struct are defined in `src/descriptors/power_system_structs.json`.

There are some unit system conventions in `PowerSystems.jl` when defining new components.
Currently, when you define components that aren't attached to a `System`,
you must define all fields in `"DEVICE_BASE"`, except for certain components that don't
have their own `base_power` rating, such as [`Line`](@ref)s, where the `rating` must be
defined in `"SYSTEM_BASE"`.

In the future, `PowerSystems.jl` hopes to support defining components in natural units.
For now, if you want to define data in natural units, you must first
set the system units to `"NATURAL_UNITS"`, define an empty component, and then use the
[accessor functions](@ref dot_access) (e.g., getters and setters), to define each field
within the component. The accessor functions will then do the data conversion from your
input data in natural units (e.g., MW or MVA) to per-unit.

By default, `PowerSystems.jl` uses `"SYSTEM_BASE"` because many optimization problems won't
converge when using natural units. If you change the unit setting, it's suggested that you
switch back to `"SYSTEM_BASE"` before solving an optimization problem (for example in
[`PowerSimulations.jl`](https://nrel-sienna.github.io/PowerSimulations.jl/stable/)).

# Time Series Data

## Categories of Time Series

The bulk of the data in many power system models is time series data. Given the potential
complexity, `PowerSystems.jl` has a set of definitions to organize this data and
enable consistent modeling.

`PowerSystems.jl` supports two categories of time series data depending on the
process to obtain the data and its interpretation:

  - [Static Time Series Data](@ref)
  - [Forecasts](@ref)

These categories are are all subtypes of `TimeSeriesData` and fall within this time series
type hierarchy:

```@repl
using PowerSystems #hide
import TypeTree: tt #hide
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); #hide
include(joinpath(docs_dir, "docs_utils.jl")); #hide
print(join(tt(TimeSeriesData), "")) #hide
```

### Static Time Series Data

A static time series data is a single column of data where each time period has a single
value assigned to a component field, such as its maximum active power. This data commonly
is obtained from historical information or the realization of a time-varying quantity.

Static time series usually comes in the following format, with a set [resolution](@ref R)
between the time-stamps:

| DateTime            | Value |
|:------------------- |:-----:|
| 2020-09-01T00:00:00 | 100.0 |
| 2020-09-01T01:00:00 | 101.0 |
| 2020-09-01T02:00:00 | 99.0  |

This example is a 1-hour resolution static time-series.

In PowerSystems, a static time series is represented using [`SingleTimeSeries`](@ref).

### Forecasts

A forecast time series includes predicted values of a time-varying quantity that commonly
includes a look-ahead window and can have multiple data values representing each time
period. This data is used in simulation with receding horizons or data generated from
forecasting algorithms.

Key forecast format parameters are the forecast [resolution](@ref R), the
[interval](@ref I) of time between forecast [initial times](@ref I), and the number of
[forecast windows](@ref F) (or forecasted values) in the forecast [horizon](@ref H).

Forecast data usually comes in the following format, where a column represents the time
stamp associated with the [initial time](@ref I) of the forecast, and the remaining columns
represent the forecasted values at each step in the forecast [horizon](@ref H).

| DateTime            | 0     | 1     | 2     | 3    | 4     | 5     | 6     | 7     |
|:------------------- |:-----:|:-----:|:-----:|:----:|:-----:|:-----:|:-----:|:----- |
| 2020-09-01T00:00:00 | 100.0 | 101.0 | 101.3 | 90.0 | 98.0  | 87.0  | 88.0  | 67.0  |
| 2020-09-01T01:00:00 | 101.0 | 101.3 | 99.0  | 98.0 | 88.9  | 88.3  | 67.1  | 89.4  |
| 2020-09-01T02:00:00 | 99.0  | 67.0  | 89.0  | 99.9 | 100.0 | 101.0 | 112.0 | 101.3 |

This example forecast has a [interval](@ref I) of 1 hour and a [horizon](@ref H) of 8.

PowerSystems defines the following Julia structs to represent forecasts:

  - [`Deterministic`](@ref): Point forecast without any uncertainty representation.
  - [`Probabilistic`](@ref): Stores a discretized cumulative distribution functions
    (CDFs) or probability distribution functions (PDFs) at each time step in the
    look-ahead window.
  - [`Scenarios`](@ref): Stores a set of probable trajectories for forecasted quantity
    with equal probability.

## Data Storage

By default PowerSystems stores time series data in an HDF5 file.
This prevents
large datasets from overwhelming system memory. Refer to this
[page](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/time_series/#Data-Format)
for details on how the time series data is stored in HDF5 files.

Time series data can be stored actual component values (for instance MW) or scaling
factors intended to be multiplied by a scalar to generate the component values.
By default PowerSystems treats the values in the time
series data as physical units. In order to specify them as scaling factors, you
must pass the accessor function that provides the multiplier value (e.g.,
`get_time_series_array`). The scaling factor multiplier
must be passed into the forecast when you create it to use this option.

The time series contains fields for `scaling_factor_multiplier` and `data`
to identify the details of  th `Component` field that the time series describes, and the
time series `data`. For example: we commonly want to use a time series to
describe the maximum active power capability of a renewable generator. In this case, we
can create a `SingleTimeSeries` with a `TimeArray` and an accessor function to the
maximum active power field in the struct describing the generator. In this way, we can
store a scaling factor time series that will get multiplied by the maximum active power
rather than the magnitudes of the maximum active power time series.

Examples of how to create and add time series to system can be found in the
[Add Time Series Example](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/add_forecasts/)