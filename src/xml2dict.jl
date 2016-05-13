function has_any_children(node_element)
    if length(collect(child_elements(node_element))) > 0
        res = true
    else
        res = false
    end
    return res
end


function isnumeric(x)
    res = false
    try
        res = typeof(parse(x)) <: Number
    end
    return res
end


function xml2dict(element_node, replace_newline = nothing)
    if has_any_children(element_node)
        ces = collect(child_elements(element_node))
        dict_res = MultiDict{Any, Any}()

        for c in ces
            childname = name(c)
            value = xml2dict(c, replace_newline)

            if isa(value, ASCIIString) && isnumeric(value)
                value = parse(value)
            elseif !isa(replace_newline, Void) && isa(value, ASCIIString)
               value = replace(value, "\n", replace_newline)
            end
            insert!(dict_res, childname, value)
        end
        return dict_res
    else
        return content(element_node)
    end
end

