
# When at a leaf node, this function returns the values in an appropriate
# form. This differs for cases when the leaf node holds an array of elements,
# a single strings, or a single number (arrays of numbers not yet implemented).

function get_values(obj)
    if length(obj) > 1
        res = string(obj)[4:end]            # first 3 chars in string are "Any"
    elseif length(obj) == 1
        if typeof(obj[1]) <: AbstractString
            res = string("\"", obj[1], "\"")
        elseif typeof(obj[1]) <: Number
            res = obj[1]
        end
    end
    return res
end



# This function is the workhorse of xml2json(). It uses recursion to fill a
# string with the keys and values of a nested multi-dictionary object
# returned by the xml2dict function.

function tags_and_values(mdict::DataStructures.MultiDict{Any, Any}, res::ASCIIString, nspaces::Int = 4)
    wspace = get_indentation(nspaces)
    nkeys = length(keys(mdict))
    res *= "\n" * wspace * "{"

    # loop over keys of multi-dictionary, and recursively fill `res`
    # string with keys and values from the multi-dictionary.
    for (i, k) in enumerate(keys(mdict))
        num_elem = length(mdict[k])

        if is_leafnode(mdict[k])
            res *= string("\n", wspace, "\"", k, "\":", get_values(mdict[k]))
            res *= (i < nkeys) ? "," : ""           # comma if non-last entry
        elseif num_elem > 1
            res *= "\n" * wspace * "\"" * k * "\":" * "["
            for j = 1:num_elem
                res = tags_and_values(mdict[k][j], res, nspaces + 4)
                res *= (j < num_elem) ? "," : ""
            end
            res *= (i < nkeys) ? "\n" * wspace * "]," : "\n" * wspace * "]"
        elseif num_elem == 1
            res *= string("\n", wspace, "\"", k, "\":")
            res = tags_and_values(mdict[k][1], res, nspaces + 4)
            res *= (i < nkeys) ? "," : ""
        end
    end
    res *= string("\n", wspace, "}")
    return res
end



function xml2json(xroot::LightXML.XMLElement, nspaces::Int = 4, replace_newline::Union{Void, ASCIIString} = "\\n")
    xmlstring = string(xroot)

    # The first element can have attributes, so its name will end either
    # with whitespace or with an close angle bracket (when no attribute).
    angle_bracket_idx = search(xmlstring, ">")[1]
    space_idx = search(xmlstring, " ")[1]
    end_idx = (angle_bracket_idx < space_idx) ? angle_bracket_idx - 1 : space_idx - 1
    heading = string("{", "\n", "\"", xmlstring[2:end_idx], "\"", ":", "\n")

    xdict = xml2dict(xroot, replace_newline)
    body = tags_and_values(xdict, "", nspaces)
    out_string = heading * body * "\n}"

    return out_string
end
