#!/usr/bin/env julia

push!(LOAD_PATH, "./")

using OdsReaders
using Printf
using PyPlot

fname = "../test/TestData.ods"
sname = "Sheet1"

d = readsheet(fname, sname)
(c, r ) = size(d)
println(d[1,2])
println(d[2:9,:])

x_name = d[1, 1]
x_data = d[2:c, 1]
y_name = d[1, 2]
y_data = d[2:c, 2]

fig = figure()
plot(x_data, y_data)
title(sname)
xlabel(x_name)
ylabel(y_name)
grid()
#savefig("output.png")
ioff()
show()
