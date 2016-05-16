module XMLconvert

using LightXML
using DataStructures

export xml2json, parse_file, parse_string, root, xml2dict, show_key_structure

include("xml_to_json.jl")
include("xml_to_dict.jl")
include("utils.jl")

end # module
