using XMLconvert
using Base.Test

file1 = "ex1.xml"
file2 = "ex2.xml"
xdoc = parse_file(file1)
xroot = root(xdoc)

xdoc2 = parse_file(file2)
xroot2 = root(xdoc2)


function xml2dict_check(root_node)
    mdict = xml2dict(root_node)
    return isa(mdict, DataStructures.MultiDict)
end


function json_conversion_check(root_node)
    json_str = xml2json(root_node)
    return isa(json_str, ASCIIString)
end


function attributes_to_elements_check(root_node)
    attributes_to_elements!(root_node)
    mdict = xml2dict(root_node)
    return mdict
end

@test xml2dict_check(xroot)
@test json_conversion_check(xroot)

muldict = attributes_to_elements_check(xroot2)

@test isa(muldict, DataStructures.MultiDict)

@test muldict["owner"][1]["age"][1] == 99
@test muldict["owner"][1]["name"][1] == "Henry Chinaski"
@test muldict["book"][1]["title"][1]["title"][1] == "Everyday Italian"

fdict = flatten(muldict)

@test haskey(fdict, "book-author")
@test haskey(fdict, "book-title-lang")
@test length(fdict["book-author"]) == 3

@test isa(show_key_structure(muldict), Void)
