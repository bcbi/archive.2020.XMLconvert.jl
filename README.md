
# XML2JSON
[![Build Status](https://travis-ci.org/paulstey/XML2JSON.jl.svg?branch=master)](https://travis-ci.org/paulstey/XML2JSON.jl)

### Installation
```{Julia}
Pkg.clone("https://github.com/paulstey/XML2JSON.jl.git")
```

Under the hood, the current implementation of `xml2json()` relies on `MultiDict` objects from the DataStructures package. The process of converting from XML to JSON involves walking through the XML that we parse with the LightXML package, and using recursion to fill a series of nested MultiDict objects.

The MultiDict is then (recursively) unpacked into an ASCIIString using the appropriate JSON formatting in the string.

Note that at this time the XML's attributes are ignored in the parsing. Any information kept here will not be preserved in the resulting JSON.

### Example
Consider the following simple XML document. This toy example was borrowed (with slight modification) from the LightXML package.
```{XML}
<?xml version="1.0" encoding="UTF-8"?>
<bookstore>
  <book>
    <title>Biography of John Adams</title>
    <author>David Smith</author>
    <author>James Jones</author>
    <year>2005</year>
    <price>30.00</price>
  </book>
  <book>
    <title>Introduction to Templates in C++</title>
    <author>Samantha Black</author>
    <year>2005</year>
    <price>29.99</price>
  </book>
  <owner>
    <name>Henry</name>
    <address>
      <state>CA</state>
      <street>123 Jones Avenue</street>
      <zip>12345</zip>
    </address>
    <age>59</age>
  </owner>
</bookstore>
```

Suppose we copy and paste the above into a file called `ex1.xml`.

### Reading in XML document
```{Julia}
using XML2JSON

filename = "ex1.xml"

# Read in XML and get its root
xdoc = parse_file(filename)
xroot = root(xdoc)

display(xroot)
```

### Convert to JSON
Next we simply provide the parsed XML's root to the `xml2json()` function.
```{Julia}
json_string = xml2json(xroot)
print(json_string)
```

### Write JSON to disk
```{Julia}
f = open("ex1.json", "w")
write(f, json_string)
```

### Spacing and Newline characters
Note that the `xml2json()` function takes two optional arguments. The first controls the spacing of the indentation in the resulting JSON. This defaults to 4, but some prefer 8. The second optional argument (and therefore, third positional argument) controls how newline characters are handled. By default, this replaces `\n` with `\\n` in the JSON's text fields. This produces valid JSON documents.
