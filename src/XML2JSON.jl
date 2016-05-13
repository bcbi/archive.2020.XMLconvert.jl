module XML2JSON

using LightXML
using DataStructures

export xml2json, parse_file

include("xml_to_json.jl")
include("xml2dict.jl")
include("utils.jl")

end # module
