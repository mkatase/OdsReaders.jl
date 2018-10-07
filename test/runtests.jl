using OdsReaders
using PyCall
using Test

@testset "OdsReaders" begin

# no file check
#@test_throws ArgumentError openods("FileNotFound.ods")

filename = normpath(@__DIR__, "TestData.ods")

# no sheet check
println("# sheet check")
@test_throws ErrorException readsheet(filename, "Sheet3")

# read sheet1 with header
println("# reading sheet1 with header")
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
println("# reading sheet1 without header")
data = readsheet(filename, "Sheet1"; header=false)
@test typeof(data) == Array{Any, 2}
@test size(data) == (8, 2)
@test data[1, 1] == 1
@test data[1, 2] == 2
@test data[8, 1] == 8
@test data[8, 2] == 20

# read sheet2 with header
println("# reading sheet2 with header")
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
println("# reading sheet4 with header")
data = readsheet(filename, "Sheet4")
@test typeof(data) == Array{Array{T,1} where T,1}
@test size(data) == (10,)
@test length(data[3]) == 3
@test data[3][1] == ""
@test data[3][2] ==  9
@test data[3][3] == 11
@test length(data[4]) == 2
@test data[4][1] ==  5
@test data[4][2] ==  8
@test length(data[5]) == 0

# check getsheets function
println("# num. of sheets")
data = getsheets(filename)
@test typeof(data) == Array{String,1}
@test length(data) == 3
@test data[3] == "Sheet4"

# check searchods function
println("# search number 2 in ods file")
data = searchods(filename, 2)
@test length(data["Sheet1"]) == 2
@test data["Sheet1"][1]==CartesianIndex(3,1)
@test data["Sheet1"][2][1]==2
@test data["Sheet1"][2][2]==2
println("# search string Z in ods file")
data = searchods(filename, "Z")
@test length(data) == 0

# check searchsheet function
println("# search number 36 in Sheet2")
data = searchsheet(filename, "Sheet2", 36)
@test data["Sheet2"][1]==CartesianIndex(7,2)
println("# search string Z in Sheet2")
data = searchsheet(filename, "Sheet2", "Z")
@test length(data) == 0
println("# search number 2 in Sheet4")
data = searchsheet(filename, "Sheet4", 2)
@test length(data["Sheet4"]) == 3
@test data["Sheet4"][1][1]==9
@test data["Sheet4"][1][2]==1
@test data["Sheet4"][2][1]==9
@test data["Sheet4"][2][2]==2
@test data["Sheet4"][3][1]==10
@test data["Sheet4"][3][2]==4
println("# search string Z in Sheet4")
data = searchsheet(filename, "Sheet4", "Z")
@test length(data) == 0
#
end
