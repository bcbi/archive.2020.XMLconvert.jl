
function xmlASCII2file(xml_string::String, file)
    xdoc = parse_string(xml_string)
    save_file(xdoc, file)
end
