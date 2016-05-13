module XMLconvert

using LightXML
using DataStructures

export xml2json, parse_file, root, xml2dict, show_key_structure

include("xml_to_json.jl")
include("xml2dict.jl")
include("utils.jl")

end # module
