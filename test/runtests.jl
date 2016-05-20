using XMLconvert
using Base.Test

fname = "ex1.xml"

function load_and_parse(filename)
    xdoc = parse_file(filename)
    xroot = root(xdoc)
    mdict = xml2dict(xroot)
    return mdict
end

chk = load_and_parse(fname)

@test isa(chk, DataStructures.MultiDict)
