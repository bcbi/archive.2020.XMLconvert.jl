
function _flatten!(mdict::MultiDict, res::Dict, parent::ASCIIString = "", sep::ASCIIString = "-", depth::Int = 1)
    sep1 = (depth == 1) ? "" : sep
    
    for k in keys(mdict)
        val = mdict[k]
        if any_multidicts(val)
            for i = 1:length(val)
                _flatten!(val[i], res, string(parent, sep1, k), sep, depth+1)
            end
        else
            newkey = string(parent, sep1, k)
            res[newkey] = append!(get(res, newkey, []), val)
        end
    end
end

function flatten(mdict::MultiDict, sep::ASCIIString = "-")
    res = Dict()
    _flatten!(mdict, res, "", sep)
    return res
end
