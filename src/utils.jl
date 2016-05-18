
function get_indentation(nspaces::Int)
    res = ""
    for i = 1:nspaces
        res *= " "
    end
    return res
end


function is_leafnode(obj)
    if isa(obj, Array{Any, 1})
        n = length(obj)
        non_dict = true
        i = 1
        while non_dict
            if !isa(obj[i], ASCIIString) && !(typeof(obj[i]) <: Number)
                non_dict = false
                res = false
            elseif i == n
                res = true
                break
            end
            i += 1
        end
    else
        res = false
    end
    return res
end


is_multidict(obj) = isa(obj, MultiDict)


function any_multidicts(v::Array{Any, 1})
    res = any(x -> isa(x, MultiDict), v)
    return res
end


function show_key_structure(xmldict_obj, nspaces = 4)
    if is_multidict(xmldict_obj)
        keys_array = collect(keys(xmldict_obj))
        indent_str = get_indentation(nspaces)
        for k in keys_array
            println(indent_str, "-", k)
            if is_multidict(xmldict_obj[k]) || typeof(xmldict_obj[k]) == Array{Any, 1}
                num_elem = length(xmldict_obj[k])
                for i = 1:num_elem
                    show_key_structure(xmldict_obj[k][i], nspaces + 4)
                    if i < num_elem
                        println(indent_str, "-", k)
                    end
                end
            end
        end
    end
end
