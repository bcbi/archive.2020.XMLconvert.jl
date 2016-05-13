module xml2json

using LightXML
using DataStructures

export xml2json, parse_file, root

include("xml_to_json.jl")
include("xml2dict.jl")
include("utils.jl")

end # module
