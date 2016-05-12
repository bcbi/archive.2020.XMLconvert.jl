
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
