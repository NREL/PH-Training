# ==============================================
# Session 2: Julia 1.10 Development: Comprehensive Guide 
# ]add QuadGK, DataFrames, Statistics, CSV, DelimitedFiles
# ==============================================

# ----------------------------------------------
# Setup: Julia Installation Verification
# ----------------------------------------------
# Run the following command to verify Julia installation
println("Hello, Julia 1.10!")  # Output: Hello, Julia 1.10!

# ----------------------------------------------
# Section: Variables and Types in Julia
# ----------------------------------------------
# Variables are containers for data; here are some examples:

my_name = "Aurelio"         # String type
my_favorite_number = 42      # Integer type
my_favorite_pi = 3.1415      # Floating-point type

# ----------------------------------------------
# Printing Variable Values
# ----------------------------------------------
println("My name is: ", my_name)  # Output: Aurelio
println("My favorite number is: ", my_favorite_number)

# ----------------------------------------------
# Mathematical Operations with Variables
# ----------------------------------------------
a, b = 2, 3  # Assigning two integers
sum = a + b  # Addition
difference = a - b  # Subtraction
product = a * b  # Multiplication
quotient = b / a  # Division
power = a^3  # Exponentiation
modulus = b % a  # Modulus

println("Sum: ", sum)             # Output: 5
println("Difference: ", difference)  # Output: 1
println("Product: ", product)       # Output: 6
println("Quotient: ", quotient)     # Output: 1.5
println("Power: ", power)           # Output: 8
println("Modulus: ", modulus)       # Output: 1

# ----------------------------------------------
# Section: Functions in Julia
# ----------------------------------------------
# Defining a function to add 2 to the input value

function plus_two(x)
    return x + 2
end

# Calling the function and printing the result
println("Result of plus_two(5): ", plus_two(5))  # Output: 7

# ----------------------------------------------
# Advanced Function: Type-Safe Function Declaration
# ----------------------------------------------
# Avoid changing the type of a variable to maintain type stability.
function multiply_by_two(n::Int64)
    return n * 2
end

function multiply_by_two(n::Float64)
    return n * 2.0
end

println("Multiply by 2: ", multiply_by_two(4))  # Output: 8

# NOTE: Uncommenting the next line will cause an error, because we declared the function to accept only Int64.
# println(multiply_by_two(4.5))  # This will raise a MethodError.

# ----------------------------------------------
# Practical Example: Choosing Types
# ----------------------------------------------
a = 2    # Integer for integer-based operations
b = 2.0  # Float64 for floating-point operations

println("Integer Operation: ", a + 1)    # Output: 3
println("Floating Operation: ", b + 1.0) # Output: 3.0

# ----------------------------------------------
# Inline Functions
# ----------------------------------------------
# Inline functions provide a concise way to define simple operations:
plus_two(x) = x + 2

# Calling the inline function
println("Inline plus_two(3): ", plus_two(3))  # Output: 5

# ----------------------------------------------
# Anonymous Functions (Lambdas)
# ----------------------------------------------
# Anonymous functions are similar to Python's lambdas:
plus_two_lambda = x -> x + 2

# Calling the anonymous function
println("Anonymous plus_two(4): ", plus_two_lambda(4))  # Output: 6

# ----------------------------------------------
# Using Functions within Functions
# ----------------------------------------------
# You can define functions inside other functions for readability:

using Pkg  # Make sure the required package is installed
Pkg.add("QuadGK")  # Install QuadGK for numerical integration

using QuadGK  # Import the package

# Nested function example
function integral_of_f(y, z)
    arg(x) = (x^2 + 2y) * z
    result = quadgk(arg, 3, 4)  # Perform integration from 3 to 4
    return result
end

# Call the function with sample values
println("Integral result: ", integral_of_f(2, 3))  # Output: Integration result

# ----------------------------------------------
# Void Functions (No Arguments, No Return Value)
# ----------------------------------------------
# Functions without arguments and return values:

function say_hi()
    println("Hello from Julia!")
end

function say_hi(name::String)
    println("$(name) is saying hello from Julia!")
end

# Call the function to see the message
say_hi()  # Output: Hello from Julia!

# ----------------------------------------------
# Optional Positional Arguments
# ----------------------------------------------
# Functions can have optional arguments with default values:

function myWeight(weightOnEarth, g = 9.81)
    return weightOnEarth * g / 9.81
end

# Call the function with and without the optional argument
println("Weight with default g: ", myWeight(70))         # Output: 70.0
println("Weight on another planet: ", myWeight(70, 3.7))  # Output: ~26.4

# ----------------------------------------------
# Handling Optional Values Gracefully
# ----------------------------------------------
# Example: Handling user-defined defaults within a function

function describe_planet(name; gravity=9.81, population=nothing)
    println("Planet: ", name)
    println("Gravity: ", gravity, " m/s²")
    if isnothing(population)
        println("Population data unavailable")
    else
        println("Population: ", population)
    end
end

# Call the function with optional keyword arguments
describe_planet("Earth")  # Default gravity, no population data
describe_planet("Mars", gravity=3.7, population=0)


# ----------------------------------------------
# Dictionaries in Julia
# ----------------------------------------------
# A dictionary stores key-value pairs:

person = Dict("Name" => "Aurelio", "Phone" => 123456789, "Shoe-size" => 40)

# Nested Dictionaries Example:
addressBook = Dict("Aurelio" => person)

person2 = Dict("Name" => "Elena", "Phone" => 987654321, "Shoe-size" => 36)
addressBook["Elena"] = person2

# Displaying the dictionary
println("Address Book: ", addressBook)

# ----------------------------------------------
# Control Flow: If-Else Statements
# ----------------------------------------------
# Example: Absolute value function using if-else

function absolute(x)
    if x >= 0
        return x
    else
        return -x
    end
end

println("Absolute of -5: ", absolute(-5))  # Output: 5

# Using elseif for multiple conditions:
x = 42
if x < 1
    println("#x < 1")
elseif x < 100
    println("#x < 100")  # Output: #x < 100
else
    println("#x is really big!")
end

# ----------------------------------------------
# Loops in Julia
# ----------------------------------------------
# For Loop: Iterating over a range

println("For Loop Example:")
for i in 1:5
    println("Iteration: ", i)
end

# While Loop: Repeats as long as the condition holds true

println("While Loop Example:")
n = 0
while n < 5
    println("Value: ", n)
    n += 1
end

# Break and Continue Statements:
println("Loop with Break:")
for i in 1:10
    if i == 5
        println("Breaking at ", i)
        break
    end
    println(i)
end

println("Loop with Continue:")
for i in 1:10
    if i % 2 == 0
        continue  # Skip even numbers
    end
    println(i)
end


# ----------------------------------------------
# Broadcasting Functions
# ----------------------------------------------
# Broadcasting works with both operators and functions. 
# Add a dot before parentheses to apply functions element-wise.

a = [1, 2, 3]  # Array
result = sin.(a)  # Apply `sin` function element-wise
println("Broadcasting result: ", result)  # Output: [0.841, 0.909, 0.141]

# Tip: Julia's for loops are optimized for performance and readability.
# Use loops or broadcasting when applying functions to multiple values.

# ----------------------------------------------
# Types and Structures in Julia
# ----------------------------------------------
# This section introduces abstract and concrete types, 
# mutable and immutable structures, and multiple dispatch.

# Defining Abstract Types
abstract type Person end
abstract type Musician <: Person end  # Musician inherits from Person

# Defining Concrete Types: Using `mutable struct` for modifiable fields
mutable struct Rockstar <: Musician
    name::String
    instrument::String
    bandName::String
    headbandColor::String
    instrumentsPlayed::Int
end

# Immutable Structure Example
struct ClassicMusician <: Musician
    name::String
    instrument::String
end

function get_name(x::Musician)
    return x.name
end

# ----------------------------------------------
# Example Usage of Types and Structures
# ----------------------------------------------

# Creating instances of the custom types
aure = Rockstar("Aurelio", "Voice", "Black Lotus", "red", 2)
mozart = ClassicMusician("Mozart", "Piano")

# Printing the instances
println("Rockstar: ", aure)
println("Classic Musician: ", mozart)

# Accessing and modifying fields in a mutable struct
aure.instrumentsPlayed += 1  # Aure learned a new instrument
println("Updated Rockstar: ", aure)

# Modifying a field in immutable struct will throw an error

# Structs with inner constrcutors
mutable struct NewRockstar <: Musician
    name::String
    instrument::String
    bandName::String
    headbandColor::String
    instrumentsPlayed::Int

    NewRockstar(name, instrument, band_name, hb_color;instr =1) = new(name, instrument, band_name, hb_color,instr)
end
# Creating instances of the custom types
new_aure = NewRockstar("Aurelio", "Voice", "Black Lotus", "red")
# ----------------------------------------------
# Working with DataFrames
# ----------------------------------------------
# First, ensure you have installed the DataFrames package:
using Pkg
Pkg.add("DataFrames")  # Run this once to install DataFrames.jl

# Import DataFrames into the session
using DataFrames

# ----------------------------------------------
# Creating a DataFrame
# ----------------------------------------------
df = DataFrame(A=1:2:1000, B=repeat(1:10, inner=50), C=1:500)

# Display the DataFrame
println("DataFrame Overview: ")
show(df, allrows=false, allcols=false)  # Sample output

# ----------------------------------------------
# Printing Options for DataFrames
# ----------------------------------------------
# Adjusting the printing options:
show(df, allrows=true)  # Prints all rows (if feasible)
show(df, allcols=true)  # Prints all columns (if feasible)

# ----------------------------------------------
# Viewing the First and Last Rows
# ----------------------------------------------
println("\nFirst 6 Rows:")
println(first(df, 6))  # View the first 6 rows

println("\nLast 6 Rows:")
println(last(df, 6))  # View the last 6 rows

# ----------------------------------------------
# Taking Subsets of DataFrames
# ----------------------------------------------
# Extracting specific rows and columns:

println("\nSubset: Rows 1 to 3, All Columns")
println(df[1:3, :])  # Select rows 1 to 3, all columns

println("\nSubset: Columns A and B")
println(df[:, [:A, :B]])  # Select all rows, only columns A and B

println("\nSubset: Specific Rows 1, 5, and 10")
println(df[[1, 5, 10], :])  # Select specific rows by index

# ----------------------------------------------
# Conditional Subsets
# ----------------------------------------------
# Selecting rows based on conditions:

filtered_df = df[df.A .> 500, :]  # Rows where column A > 500
filter(x -> x.A > 500, df)
println("\nFiltered Data (A > 500):")
println(filtered_df)

filtered_df2 = df[(df.A .> 500) .& (300 .< df.C .< 400), :]
filter(x -> (x.A > 500 && 300 < x.C < 400), df)
println("\nFiltered Data (A > 500 and 300 < C < 400):")
println(filtered_df2)

# ----------------------------------------------
# Adding and Modifying Columns
# ----------------------------------------------
# Adding a new column:
df.new_col = df.A .* 2  # New column as double of A
println("\nDataFrame with New Column:")
println(first(df, 5))  # Display first few rows with new column


# ----------------------------------------------
# Summarizing DataFrames: Basic Statistics
# ----------------------------------------------
# Use the `describe` function to summarize data:

using DataFrames

df = DataFrame(A=1:4, B=["M", "F", "F", "M"])

println("Data Summary:")
println(describe(df))  # Output: Statistical summary of the DataFrame

# ----------------------------------------------
# Computing Statistics for Individual Columns
# ----------------------------------------------
# Compute the mean of a column:

using Statistics
println("Mean of A: ", mean(df.A))  # Output: 2.5

# ----------------------------------------------
# Importing and Exporting Data (I/O)
# ----------------------------------------------
# CSV.jl allows reading and writing CSV files.

using Pkg
Pkg.add("CSV")  # Install CSV.jl if not already installed

using CSV  # Import the package

# Create a sample DataFrame
df = DataFrame(x=1:3, y=["a", "b", "c"])

# Writing the DataFrame to a CSV file
CSV.write("sample.csv", df)  # Saves the DataFrame to 'sample.csv'

println("\nDataFrame saved to 'sample.csv'")

# Reading the DataFrame back from the CSV file
df_from_csv = DataFrame(CSV.File("sample.csv"))

println("\nDataFrame loaded from 'sample.csv':")
println(df_from_csv)

# ----------------------------------------------
# Handling Large Datasets with DelimitedFiles
# ----------------------------------------------
# For simple cases where latency is an issue, use `DelimitedFiles`.

using DelimitedFiles

# Create a sample CSV file for demonstration
path = "sample.csv"
readdlm(path, ',', header=true)  # Read data with headers

# Handling data and headers separately
data, header = readdlm(path, ',', header=true)
df_raw = DataFrame(data, vec(header))

# Displaying the DataFrame with processed data
println("\nLoaded and processed DataFrame:")
println(df_raw)




