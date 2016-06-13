
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
    if search(x, ['(', ')', '[', ']']) == 0   # these chars make parse() throw warning
        try
            res = typeof(parse(x)) <: Number
        end
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




# This function converts *some* attributes to elements in
# a parsed XML doc. In particular, it will only convert those
# attributes that are in self-closing tags. Those attributes
# that are part of a node whose content is not equal to "" will
# be ignored by this function. Note that the function modifies
# the parsed XML document in place.

function attributes_to_elements!(element_node)
    if has_any_children(element_node)
        ces = collect(child_elements(element_node))
        for c in ces
            attributes_to_elements!(c)
        end
    elseif content(element_node) == ""
        if has_attributes(element_node)
            attr_dict_array = Array{Dict}(0)
            push!(attr_dict_array, attributes_dict(element_node))
            for i = 1:length(attr_dict_array)
                for (k, v) in zip(keys(attr_dict_array[i]), values(attr_dict_array[i]))
                    elem = new_child(element_node, k)
                    add_text(elem, v)
                end
            end
        end
    end
end



