module OdsReaders

using PyCall
using Printf

export openods, readsheet, getsheets
export searchods, searchsheet

const py_pip = PyNULL()
const py_ods = PyNULL()

function __init__()
    u = pyimport("importlib.util")
    if u[:find_spec]("pyexcel_ods") == nothing
        py_pip = pyimport("pip._internal")
        py_pip[:main](["install","pyexcel-ods"])
        #@pyimport pip._internal as p
    end
    copy!(py_ods, pyimport("pyexcel_ods"))
end

"""
   openods function

   Open ods file and return all sheet data
   ods file is for OpenDocument SpreadSheet (e.g. LibreOffice Calc)
   if no file, return nothing

"""
function openods(filename::AbstractString)
    if !isfile(filename)
        error("$filename : file not found")
    else
        return py_ods[:get_data](filename)
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
        return error()
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

"""
    search string function in ods file (All Sheets)

    retrun search string dictionary of data
    key is sheet name, value is list of tuple(row, col)

"""
function searchods(filename::AbstractString, target)
    D = Dict() # Initilization
    for (k,v) in openods(filename)
        D = merge(D, searchdata(k, v, target))
    end
    D 
end

"""
    search string function in a sheet

    retrun search string dictionary of data
    key is sheet name, value is list of tuple(row, col)
"""
function searchsheet(filename::AbstractString, shname::AbstractString, target)
   d = readsheet(filename, shname)
   searchdata(shname, d, target) 
end

"""
    internal function of searching row and col value 
"""
function searchdata(key, val, m)
    D = Dict()
    if length(size(val)) == 1
        # lack of data matrix
        for i in 1:length(val)
            o = findall(x->x==m, val[i])
            if length(o) != 0
                get!(D, key, [])
                append!(D[key], [ (i,j) for j in o ])
            end
        end
    else
        # full data matrix
        o = findall(x->x==m, val)
        if length(o) != 0
            D[key] = o
        end
    end
    D
end

end # module
