module XMLconvert

using LightXML
using DataStructures

export xml2json, xml2dict, parse_file, parse_string,
       root, show_key_structure, flatten

include("xml_to_json.jl")
include("xml_to_dict.jl")
include("utils.jl")
include("flatten_multidict.jl")

end # module
