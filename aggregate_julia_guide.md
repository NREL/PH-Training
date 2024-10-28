
# Julia 1.10 Development in VSCode: Comprehensive Beginner’s Guide

---

## Overview  
This guide walks through setting up Julia 1.10 with Visual Studio Code (VSCode) and mastering the basics to develop Julia applications. It is tailored for beginners looking to use Julia for scientific computing, data analysis, or power system modeling.

---

## 1. Setting up Julia 1.10 in VSCode  

1. Install **Julia 1.10** from the [Julia Downloads Page](https://julialang.org/downloads/).  
2. Download and install **Visual Studio Code** from [VSCode](https://code.visualstudio.com/).
3. Open the **Extensions tab** (`Ctrl+Shift+X`), search for **Julia**, and click "Install."
4. Verify installation:
   - Open the **Command Palette** (`Ctrl+Shift+P`) and type `Julia: Start REPL`.
   - Run the following command in the REPL:
     ```julia
     println("Hello, Julia 1.10!")
     ```

---

# Variables and Types in Julia 1.10

### Overview  
In this lesson, you'll learn about **variables** and how to perform basic mathematical operations in Julia. You'll also explore the concept of **types**, which determine how Julia handles data efficiently. Understanding these concepts will set a foundation for writing performant Julia programs.

---

## 1. Variables: Containers for Data  
A **variable** is a named container that holds data. Think of it as a label for a value. Variables make it easier to manipulate and reference data throughout a program.

### Creating Variables  
You can assign data to variables using the `=` symbol:

```julia
my_name = "Aurelio"         # String type
my_favorite_number = 42      # Integer type
my_favorite_pi = 3.1415      # Floating-point type
```

In Julia, **you don't need to specify the type** when creating a variable—Julia infers it automatically. For example, `"Aurelio"` is inferred as a `String`.

---

### 2. Printing Variable Values  
To print a variable’s value, use the `print` or `println` functions:

```julia
println(my_name)
# Output: Aurelio
```

---

### 3. Performing Mathematical Operations  
Julia allows you to perform standard arithmetic operations:

```julia
a = 2
b = 3

sum = a + b            # Addition
difference = a - b      # Subtraction
product = a * b         # Multiplication
quotient = b / a        # Division
power = a^3             # Exponentiation
modulus = b % a         # Modulus (remainder)
```

Julia also supports **rational numbers** for precise computations. Use the `//` syntax:

```julia
exact_value = 1 // 3
println(exact_value)  # Output: 1//3
```

For a complete list of mathematical operations, refer to Julia’s official documentation [here](https://docs.julialang.org/en/v1/manual/mathematical-operations/).

---

### 4. Introduction to Types  
Every value in Julia has a **type**. Types are organized in a hierarchical structure. At the top is the `Any` type, meaning all objects belong to this type. Below it, there are more specific types, such as `Number`, which is divided further into `Real` and `Complex`.

### Common Types in Julia
- **Int64**: Integer values
- **Float64**: Floating-point numbers
- **String**: Text data
- **Bool**: Boolean (true/false) values

Here is a simple type hierarchy for numbers:

```
Any
└── Number
    ├── Real
    │   ├── Int
    │   └── Float64
    └── Complex
```

This hierarchy ensures that functions operating on a **general type** (like `Number`) can also work on any **subtypes** (like `Float64` or `Int`).

---

### 5. Checking and Converting Types  
Use the `typeof` function to check the type of a variable:

```julia
println(typeof(0.1))   # Output: Float64
println(typeof(42))    # Output: Int64
println(typeof("Julia"))  # Output: String
```

You can **convert types** explicitly using the `convert` function:

```julia
a = 2
b = convert(Float64, a)

println(a)  # Output: 2
println(b)  # Output: 2.0
```

---

### 6. Type Stability for Performance  
In Julia, it’s recommended to keep variables **type-stable** for optimal performance. This means that the type of a variable should remain the same throughout its usage. For example:

```julia
a = 2   # Integer
# Avoid changing `a` to a Float64 later:
# a = 2.0  # Bad practice: Changing type can hurt performance
```

---

### 7. Practical Example: Choosing Types  
When you need to operate with integers or floats, it's better to initialize them with appropriate values:

```julia
a = 2    # Integer for integer-based operations
b = 2.0  # Float64 for floating-point operations
```

---

### Conclusion  
In this lesson, you’ve learned:
- How to define variables and print their values.
- Basic arithmetic operations in Julia.
- The concept of types and how Julia optimizes performance using type stability.
- How to check and convert variable types.

---

# Variables and Types 

#### Variables: Containers for Data  
A **variable** is a named container that holds data. Think of it as a label for a value. Variables make it easier to manipulate and reference data throughout a program.

```julia
my_name = "Aurelio"  # String type
my_favorite_number = 42  # Integer type
my_favorite_pi = 3.1415  # Floating-point type
```

#### Printing Variable Values  
To print a variable’s value, use the `print` or `println` functions:
```julia
println(my_name)  # Output: Aurelio
```

#### Mathematical Operations  
Julia allows standard arithmetic operations:
```julia
a, b = 2, 3
sum = a + b
difference = a - b
product = a * b
quotient = b / a
power = a^3
modulus = b % a
```

---

## Functions in Julia

#### Defining Functions  
A function is a reusable block of code that takes input, performs operations, and returns an output. In Julia, a typical function looks like this:

```julia
function plus_two(x)
    return x + 2
end
```

Inline functions provide a concise way to define simple operations:
```julia
plus_two(x) = x + 2
```

#### Anonymous Functions  
Anonymous functions (similar to lambdas in Python) can be defined as:
```julia
plus_two = x -> x + 2
```

They are useful for short, one-off operations but are generally discouraged for complex logic.

---

#### Using Functions within Functions  
You can define functions inside other functions for readability:

```julia
function integral_of_f(y, z)
    arg(x) = (x^2 + 2y) * z
    result = quadgk(arg, 3, 4)
    return result
end
```

Install the necessary package using:
```julia
using Pkg
Pkg.add("QuadGK")
using QuadGK
```

---

#### Void Functions (No Arguments, No Return Value)  
Some functions take no arguments and return no value:
```julia
function say_hi()
    println("Hello from Julia!")
end
```

#### Optional Positional Arguments  
Functions can have optional arguments with default values:
```julia
function myWeight(weightOnEarth, g = 9.81)
    return weightOnEarth * g / 9.81
end

println(myWeight(60))        # Output: 60
println(myWeight(60, 3.72))  # Weight on Mars: 22.75
```

#### Keyword Arguments  
When a function has many optional parameters, keyword arguments improve clarity. Use a semicolon `;` to separate them from positional arguments:
```julia
function my_long_function(a, b = 2; c, d = 3)
    return a + b + c + d
end

println(my_long_function(1, c = 3))   # Output: 9
println(my_long_function(1, 2, d = 5, c = 3))  # Output: 11
```

Keyword arguments must always be specified by name:
```julia
my_long_function(1, 2, d = 5)  # Error: keyword argument `c` not assigned
```

---

#### Performance Tip  
Use **positional arguments** for performance-critical functions, as they are faster than keyword arguments. For flexibility, you can wrap the function with keyword arguments in a separate method.

---

#### Function Documentation  
Use the `?` symbol in the REPL to access documentation:
```julia
?sin  # Documentation for the `sin` function
```

You can also document your functions like this:
```julia
"""
This function adds two numbers.
"""
function add(a, b)
    return a + b
end
```

---

#### Conclusion  
Functions are the backbone of Julia programs. In this lesson, you learned:
- How to define functions, including anonymous and void functions.
- How to use optional positional and keyword arguments.
- How to access and write function documentation.
---

## Data Structures in Julia  

In this lesson, we explore **arrays**, **vectors**, **matrices**, **tuples**, and **dictionaries**—essential tools for organizing and storing data in memory.

---

#### Arrays and Vectors  
A **vector** is a one-dimensional array containing ordered elements of the same type. While arrays are generic containers, vectors are often referred to as one-dimensional arrays in Julia.

```julia
a = [1, 2, 3, 4, 5]
b = [1.2, 3, 4, 5]
c = ["Hello", "it's me", "Julia"]
```

In Julia, **arrays start at index 1**. Use brackets to access elements:
```julia
println(c[3])  # Output: it's me
```

##### Appending Elements  
To append an element to a vector, use `append!`:
```julia
append!(a, 6)
println(a)  # Output: [1, 2, 3, 4, 5, 6]
```

If the type of the new element doesn’t match the array’s type, Julia will raise an error:
```julia
append!(a, 3.14)  # Error: InexactError: Int64(2.3)
```

---

#### Matrices and N-Dimensional Arrays  
A **matrix** is a two-dimensional array. Use spaces to separate columns and semicolons for rows:
```julia
mat1 = [1 2 3; 4 5 6]
println(mat1[1, 2])  # Access element at row 1, column 2
```

Use the `zeros` function to create n-dimensional arrays and populate them with values:
```julia
table = zeros(2, 3, 4)
for k in 1:4, j in 1:3, i in 1:2
    table[i, j, k] = i * j * k
end
println(table)
```

---

#### Slicing and Views  
Julia supports slicing to extract subarrays:
```julia
a = [1, 2, 3, 4, 5, 6]
b = a[2:5]  # Output: [2, 3, 4, 5]
```

Nested slicing is also supported:
```julia
mat1 = reshape([i for i in 1:16], 4, 4)
mat2 = mat1[2:3, 2:3]
```

##### Views vs Copies  
Assigning arrays creates a reference, not a copy:
```julia
a = [1, 2, 3]
b = a
b[2] = 42
println(a)  # Output: [1, 42, 3]
```

To create a **copy**, use:
```julia
b = copy(a)
```

---

#### Tuples and Named Tuples  
A **tuple** is an immutable collection of elements:
```julia
tuple1 = (1, 2, 3)
a, b, c = tuple1
println("#a #b #c")  # Output: 1 2 3
```

Use **named tuples** to label tuple elements:
```julia
named_tuple = (a = 1, b = "hello")
println(named_tuple[:a])  # Output: 1
```

---

#### Dictionaries  
A **dictionary** stores key-value pairs:
```julia
person = Dict("Name" => "Aurelio", "Phone" => 123456789, "Shoe-size" => 40)
```

You can store dictionaries within dictionaries:
```julia
addressBook = Dict("Aurelio" => person)
person2 = Dict("Name" => "Elena", "Phone" => 123456789, "Shoe-size" => 36)
addressBook["Elena"] = person2
```

---

#### Conclusion  
In this lesson, we explored essential data structures like arrays, tuples, and dictionaries. These structures are key to organizing data in Julia programs and are essential for working with more complex operations.

---
## Control Flow in Julia

In this section, we explore the control flow mechanisms in Julia, including conditional statements and loops.

---

#### If … else Statements  

Conditional statements allow programs to take different actions depending on conditions.

```julia
function absolute(x)
    if x >= 0
        return x
    else
        return -x
    end
end
```

You can use **`elseif`** for more conditions:
```julia
x = 42
if x < 1
    println("#x < 1")
elseif x < 100
    println("#x < 100")
else
    println("#x is really big!")
end
```

---

#### For Loops  

Use `for` loops to iterate over collections:
```julia
for i in 1:10
    println(i^2)
end
```

You can also loop through arrays:
```julia
persons = ["Alice", "Bob", "Carla"]
for person in persons
    println("Hello #person!")
end
```

---

#### Break and Continue  

- **`break`** stops the loop immediately:
```julia
for i in 1:100
    if i > 10
        break
    end
    println(i^2)
end
```

- **`continue`** skips the current iteration:
```julia
for i in 1:30
    if i % 3 == 0
        continue
    end
    println(i)
end
```

---

#### While Loops  

Use a `while` loop when the number of iterations isn’t known beforehand:
```julia
function while_test()
    i = 0
    while i < 30
        println(i)
        i += 1
    end
end
```

---

#### Enumerate  

The `enumerate` function allows you to loop through a collection with an index:
```julia
x = ["a", "b", "c"]
for (i, value) in enumerate(x)
    println("(#i, #value)")
end
```

This can also be used for populating arrays:
```julia
my_array1 = collect(1:10)
my_array2 = zeros(10)

for (i, element) in enumerate(my_array1)
    my_array2[i] = element^2
end
println(my_array2)  # Output: [1.0, 4.0, 9.0, ..., 100.0]
```

Alternatively:
```julia
for i in 1:length(my_array1)
    my_array2[i] = my_array1[i]^2
end
println(my_array2)
```

---

This section completes the discussion on control flow mechanisms in Julia, ensuring you understand how to manage logic and repetition efficiently.

---

## Working with Arrays: Broadcasting  

Broadcasting is one of Julia's most useful features. It allows operations to be applied element-by-element on arrays in a concise and efficient way. This section also explores the differences between Julia and languages like Python or Matlab in handling arrays.

---

### Operations with Arrays  
Julia handles arrays mathematically. However, certain operations (like sine) cannot operate on entire arrays directly but instead on individual elements. Other operations, such as matrix multiplication, follow standard mathematical rules.

```julia
a = [1, 2, 3]  # Column vector
b = [4, 5, 6]  # Another column vector

# Multiplying vectors directly raises an error:
a * b  # ERROR: MethodError

c = [4 5 6]  # Row vector

# Matrix multiplication works when dimensions match:
a * c  # 3x3 matrix output

d = reshape([1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3)
result = d * a  # 3-element vector result
println(result)  # Output: [30, 36, 42]
```

---

### Broadcasting in Julia  

To perform **element-wise operations**, Julia uses **broadcasting**, which is achieved by placing a dot (`.`) before an operator.

```julia
a = [1, 2, 3]
c = [4 5 6]

# Element-wise multiplication using broadcasting:
result = a .* c
println(result)  # 3x3 matrix with element-wise multiplication

d = reshape([1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3)
broadcasted_result = a .* d
println(broadcasted_result)
```

Output:
```
3×3 Array{Int64,2}:
 1   4   7
 4  10  16
 9  18  27
```

---

### Broadcasting Functions  

Broadcasting works not only with operators but also with functions. Simply add a dot before the parentheses to apply a function element-wise.

```julia
a = [1, 2, 3]
result = sin.(a)
println(result)  # Output: [0.841, 0.909, 0.141]
```

Tip: Avoid writing vectorized code (like in Python or Matlab) unless necessary. Julia's for loops are fast, readable, and less error-prone. Use loops or broadcasting when you need to apply functions to multiple values.

---

## Types and Structures in Julia  

This section introduces types in Julia and demonstrates how to use them effectively. We'll explore **abstract and concrete types**, define **mutable and immutable structures**, and discuss **type constructors**. Additionally, we’ll cover **multiple dispatch**, one of Julia’s most powerful features.

---

### Implementation: Defining Types  

To declare a **type**, use the `abstract type` or `struct` keywords.

```julia
abstract type Person end
abstract type Musician <: Person end  # Musician is a subtype of Person
```

Concrete types are declared with `struct`. Use `mutable struct` for types whose fields can change.

```julia
mutable struct Rockstar <: Musician
    name::String
    instrument::String
    bandName::String
    headbandColor::String
    instrumentsPlayed::Int
end

struct ClassicMusician <: Musician
    name::String
    instrument::String
end
```

### Example Usage  

```julia
aure = Rockstar("Aurelio", "Voice", "Black Lotus", "red", 2)
println(aure.headbandColor)  # Output: red

aure_musician = ClassicMusician("Aurelio", "Violin")
# Immutable fields cannot be changed:
aure_musician.instrument = "Cello"  # ERROR: immutable struct cannot be changed
```

---

### Functions and Types: Multiple Dispatch  

Multiple dispatch allows functions to behave differently depending on the type of their inputs. Below are examples:

```julia
function introduceMe(person::Person)
    println("Hello, my name is $(person.name).")
end

function introduceMe(person::Musician)
    println("Hello, my name is $(person.name) and I play $(person.instrument).")
end
```

---

### Type Constructors  

Type constructors simplify creating instances of types. Below is a custom constructor that computes initial values:

```julia
mutable struct MyData
    x::Float64
    x2::Float64
    y::Float64
    z::Float64

    function MyData(x::Float64, y::Float64)
        x2 = x^2
        z = sin(x2 + y)
        new(x, x2, y, z)
    end
end

data = MyData(2.0, 3.0)
println(data)  # Output: MyData(2.0, 4.0, 3.0, 0.656...)
```

---

### Parametric Types  

Julia allows **parametric types**, which provide flexibility:

```julia
mutable struct MyData2{T<:Real}
    x::T
    x2::T
    y::T
    z::Float64

    function MyData2{T}(x::T, y::T) where T<:Real
        x2 = x^2
        z = sin(x2 + y)
        new(x, x2, y, z)
    end
end

data2 = MyData2{Float64}(2.0, 3.0)
println(data2)  # Output: MyData2{Float64}(2.0, 4.0, 3.0, ...)
```

---

### Example: Circle Module  

Here is an example module that defines a `Circle` type and functions to compute its area and perimeter.

```julia
module TestModuleTypes

export Circle, computePerimeter, computeArea, printCircleEquation

mutable struct Circle{T<:Real}
    radius::T
    perimeter::Float64
    area::Float64

    function Circle{T}(radius::T) where T<:Real
        new(radius, -1.0, -1.0)
    end
end

function computePerimeter(circle::Circle)
    circle.perimeter = 2 * π * circle.radius
    return circle.perimeter
end

function computeArea(circle::Circle)
    circle.area = π * circle.radius^2
    return circle.area
end

function printCircleEquation(xc::Real, yc::Real, circle::Circle)
    println("(x - $xc)^2 + (y - $yc)^2 = $(circle.radius^2)")
end

end  # end module

using .TestModuleTypes

circle1 = Circle{Float64}(5.0)
computePerimeter(circle1)
computeArea(circle1)
printCircleEquation(2, 3, circle1)
```

---

This section covered how to define abstract and concrete types, use mutable and immutable structures, leverage type constructors, and apply multiple dispatch. In future lessons, we’ll continue using types to build more complex data structures and models.

---

## First Steps with DataFrames.jl

## Setting up the Environment

If you want to use the `DataFrames.jl` package, you need to install it first. You can do it using the following commands:

```julia
julia> using Pkg
julia> Pkg.add("DataFrames")
```

or

```julia
(@v1.9) pkg> add DataFrames
```

If you want to make sure everything works as expected you can run the tests bundled with `DataFrames.jl`, but be warned that it will take more than 30 minutes:

```julia
julia> using Pkg
julia> Pkg.test("DataFrames") # Warning! This will take more than 30 minutes.
```

Additionally, it is recommended to check the version of `DataFrames.jl` that you have installed with the `status` command.

```julia
(@v1.9) pkg> status DataFrames
      Status `~1.6\Project.toml`
  [a93c6f00] DataFrames v1.5.0
```

Throughout the rest of the tutorial, we will assume that you have installed the `DataFrames.jl` package and have already typed `using DataFrames`, which loads the package:

```julia
julia> using DataFrames
```

The most fundamental type provided by `DataFrames.jl` is `DataFrame`, where typically each row is interpreted as an observation and each column as a feature.

...

Here is the markdown version of the provided guide:


## Examining the Data

The default printing of `DataFrame` objects only includes a sample of rows and columns that fit on screen:

```julia
using DataFrames

df = DataFrame(A=1:2:1000, B=repeat(1:10, inner=50), C=1:500)
```

```plaintext
500×3 DataFrame
 Row │ A      B      C
     │ Int64  Int64  Int64
─────┼─────────────────────
   1 │     1      1      1
   2 │     3      1      2
   3 │     5      1      3
   ⋮ │   ⋮      ⋮      ⋮
 500 │   999     10    500
```

### Printing Options

You can adjust the printing options using the `show` function:

- `show(df, allrows=true)`: prints all rows.
- `show(df, allcols=true)`: prints all columns.

### Viewing the First and Last Rows

You can use the `first` and `last` functions to view the beginning and end of a `DataFrame`:

```julia
first(df, 6)
```

```plaintext
6×3 DataFrame
 Row │ A      B      C
─────┼─────────────────
   1 │     1      1      1
   2 │     3      1      2
   3 │     5      1      3
```

```julia
last(df, 6)
```

```plaintext
6×3 DataFrame
 Row │ A      B      C
─────┼─────────────────
   1 │   989     10    495
   2 │   991     10    496
   ⋮ │   ⋮      ⋮      ⋮
   6 │   999     10    500
```

Notice how type information is provided for columns in a `DataFrame`. For instance:

```julia
using CategoricalArrays

df = DataFrame(a=1:2, b=[1.0, missing], c=categorical('a':'b'), d=[1//2, missing])
```

```plaintext
2×4 DataFrame
 Row │ a      b         c     d
─────┼─────────────────────────
   1 │     1      1.0   a     1//2
   2 │     2  missing   b     missing
```

### Subsetting DataFrames

You can use indexing syntax to extract specific subsets of data from a `DataFrame`:

```julia
df[1:3, :]
```

```plaintext
3×3 DataFrame
 Row │ A      B      C
─────┼─────────────────
   1 │     1      1      1
   2 │     3      1      2
   3 │     5      1      3
```

### Selecting Columns

To select specific columns:

```julia
df[:, [:A, :B]]
```

```plaintext
500×2 DataFrame
 Row │ A      B
─────┼──────────
   1 │     1      1
   2 │     3      1
   ⋮ │   ⋮      ⋮
 500 │   999     10
```

You can also select columns matching a regular expression:

```julia
df[!, r"x"]
```

### Conditional Subsetting

To filter rows based on conditions:

```julia
df[df.A .> 500, :]
```

```plaintext
250×3 DataFrame
 Row │ A      B      C
─────┼─────────────────
   1 │   501      6    251
   2 │   503      6    252
   ⋮ │   ⋮      ⋮      ⋮
 250 │   999     10    500
```

You can also use logical conditions:

```julia
df[(df.A .> 500) .& (300 .< df.C .< 400), :]
```

### Column Selection with `Not` and `Between`

Use `Not` to exclude specific columns:

```julia
df[:, Not(:A)]
```

Select columns within a range:

```julia
df[:, Between(:A, :B)]
```

### Transforming Columns

To apply transformations to columns:

```julia
df = DataFrame(x1=[1, 2], x2=[3, 4], y=[5, 6])

select(df, :x1, :x2 => (x -> x .- minimum(x)) => :x2_transformed)
```

```plaintext
2×2 DataFrame
 Row │ x1     x2_transformed
─────┼───────────────────────
   1 │     1               0
   2 │     2               1
```

### Summary Statistics

Use `describe` to get an overview of a `DataFrame`:

```julia
describe(df)
```

```plaintext
2×7 DataFrame
 Row │ variable  mean  min  median  max  nmissing  eltype
─────┼───────────────────────────────────────────────
   1 │ A         2.5    1    2.5     4         0  Int64
   2 │ B                F          M         0  String
```

Compute statistics for individual columns:

```julia
using Statistics
mean(df.A)
```

```plaintext
2.5
```

This guide demonstrates common tasks in working with `DataFrames` in Julia, including subsetting, selecting, and transforming columns, along with viewing and summarizing data.

## Importing and Exporting Data (I/O)

### CSV Files

For reading and writing tabular data from CSV and other delimited text files, use the `CSV.jl` package.

If you have not used the `CSV.jl` package before, then you may need to install it first:

```julia
using Pkg
Pkg.add("CSV")
```

The `CSV.jl` functions are not loaded automatically and must be imported into the session:

```julia
using CSV
```

A dataset can now be read from a CSV file at path input using:

```julia
DataFrame(CSV.File(input))
```

A `DataFrame` can be written to a CSV file at path output using:

```julia
df = DataFrame(x=1, y=2)
CSV.write(output, df)
```

For more details on `CSV.jl`, see `?CSV.File`, `?CSV.read`, and `?CSV.write`, or check out the online `CSV.jl` documentation.

...

## DelimitedFiles Module

In simple cases, when compilation latency of `CSV.jl` might be an issue, using the `DelimitedFiles` module from the Julia standard library can be considered. Below is an example showing how to read in the data and perform its post-processing:

```julia
julia> using DelimitedFiles, DataFrames

julia> path = joinpath(pkgdir(DataFrames), "docs", "src", "assets", "iris.csv");

julia> data, header = readdlm(path, ',', header=true);

julia> iris_raw = DataFrame(data, vec(header))
150×5 DataFrame
 Row │ SepalLength  SepalWidth  PetalLength  PetalWidth  Species
     │ Any          Any         Any          Any         Any
─────┼──────────────────────────────────────────────────────────────
   1 │ 5.1          3.5         1.4          0.2         Iris-setosa
   2 │ 4.9          3.0         1.4          0.2         Iris-setosa
   3 │ 4.7          3.2         1.3          0.2         Iris-setosa
   4 │ 4.6          3.1         1.5          0.2         Iris-setosa
   5 │ 5.0          3.6         1.4          0.2         Iris-setosa
   ⋮   ⋮           ⋮            ⋮           ⋮             ⋮
 150 │ 5.9          3.0         5.1          1.8         Iris-virginica
```

This section demonstrates the use of the `DelimitedFiles` module for reading and processing CSV data.
