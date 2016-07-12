
function xmlASCII2file(xml_string::ASCIIString, file)
    xdoc = parse_string(xml_string)
    save_file(xdoc, file)
end
