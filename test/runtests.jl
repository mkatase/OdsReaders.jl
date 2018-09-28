using TestPackage
using PyCall
using Test

@testset "TestPackage" begin

data = openods("FileNotFound.ods")
@test data == nothing

filename = normpath(@__DIR__, "TestData.ods")
#file = openods(filename)
#@test filename == "TestData.ods"



# no sheet check
@test readsheet(filename, "Sheet3") == Dict{Any,Any}()

# read sheet1 with header
data = readsheet(filename, "Sheet1")
@test typeof(data) == Array{Any, 2}
@test size(data) == (9, 2)
@test data[1, 1] == "#X"
@test data[1, 2] == "#Y"
@test data[2, 1] == 1
@test data[2, 2] == 2
@test data[5, 1] == 4
@test data[5, 2] == 9
@test data[9, 1] == 8
@test data[9, 2] == 20

# read sheet1 without header
data = readsheet(filename, "Sheet1"; header=false)
@test typeof(data) == Array{Any, 2}
@test size(data) == (8, 2)
@test data[1, 1] == 1
@test data[1, 2] == 2
@test data[8, 1] == 8
@test data[8, 2] == 20

# read sheet2 with header
data = readsheet(filename, "Sheet2")
@test typeof(data) == Array{Any, 2}
@test size(data) == (11, 2)
@test data[1, 1] == "#A"
@test data[1, 2] == "#B"
@test data[4, 1] == 3
@test data[4, 2] == 9
@test data[11, 1] == 10
@test data[11, 2] == 133

# read sheet4 with header
data = readsheet(filename, "Sheet4")
@test typeof(data) == Array{Array{T,1} where T,1}
@test size(data) == (7,)
@test length(data[3]) == 3
@test data[3][1] == ""
@test data[3][2] ==  9
@test data[3][3] == 11
@test length(data[4]) == 2
@test data[4][1] ==  5
@test data[4][2] ==  8
@test length(data[5]) == 0

# check getsheets function
data = getsheets(filename)
@test typeof(data) == Array{String,1}
@test length(data) == 3
@test data[3] == "Sheet4"

end
