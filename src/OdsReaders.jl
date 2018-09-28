module OdsReaders

using PyCall
using Printf

export openods, readsheet, getsheets

const pyexcel_ods = PyNULL()

#include("package_documentation.jl")

function __init__()
    copy!(pyexcel-ods, pyimport_conda("pyexcel-ods", "pyexcel-ods"))
end

"""
   openods function

   Open ods file and return all sheet data
   ods file is for OpenDocument SpreadSheet (e.g. LibreOffice Calc)
   if no file, return nothing

"""
function openods(filename::AbstractString)
    if !isfile(filename)
        println("$filename : file not found")
        return nothing
    else
        return pyexcel_ods[:get_data](filename)
    end
end

"""
    readsheet function

    open ods file, set a target sheet name and args
    return sheet data for a target sheet
 
"""
function readsheet(filename::AbstractString, shname::AbstractString; args...)
    data = openods(filename)
    if haskey(data, shname)
        return conv_args(data[shname]; args...)
    else
        @printf "%s : sheet not found\n" shname
        return Dict()
    end
end

"""
    convert args function
    if header flag is false, first column of data is skipped
    if header flag is true, first column of data is not skipped

"""
function conv_args(sheet; header=true)
    if !isa(header, Bool)
        error("true or false is a valid argument for header")
    else
        if header
            return sheet
        else
            (r, c) = size(sheet)
            return sheet[2:r,:]
        end
    end
end

"""
    getsheet name function

    return sheet name lists of data

"""
function getsheets(filename::AbstractString)
    data = openods(filename)
    return [ k for (k,v) in data]
end

end # module
