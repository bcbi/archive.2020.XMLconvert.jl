# XML2JSON
## XML2JSON
Under the hood, the current implementation of `xml2json()` relies on `MultiDict` objects from the DataStructures package. The process of converting from XML to JSON involves walking through the XML that we parse with the LightXML package, and using recursion to fill a series of nested MultiDict objects.

Note that at this time the XML's attributes are ignored in the parsing. Any information kept here will not be preserved in the resulting JSON.

### Installation
```{Julia}
Pkg.clone("https://github.com/paulstey/XML2JSON.jl.git")
```

### Example
Consider the following simple XML document. This example is borrowed from the LightXML package and appears in `/data/ex1.xml` directory of this repo.
```{XML}
<?xml version="1.0" encoding="UTF-8"?>
<bookstore>
  <book>
    <title>Everyday Italian</title>
    <author>Giada De Laurentiis</author>
    <author>James Fakename</author>
    <year>2005</year>
    <price>30.00</price>
  </book>
  <book>
    <title>Harry Potter</title>c
    <author>J K. Rowling</author>
    <year>2005</year>
    <price>29.99</price>
  </book>
  <owner>
    <name>Henry</name>
    <address>
      <state>CA</state>
      <street>123 Jones Ave</street>
      <zip>12345</zip>
    </address>
    <age>99</age>
  </owner>
</bookstore>
```

### Reading in XML document
```{Julia}
include("./src/xml2son.jl")

filename = "./data/ex1.xml"

# Read in XML and get its root
xdoc = parse_file(filename)
xroot = root(xdoc)

display(xroot)
```

### Convert to JSON
Next we simply provide the parsed XML's root to the `xml2json()` function.
```{Julia}
json_string = xml2json(xroot)
```

### Write JSON to disk


[![Build Status](https://travis-ci.org/paulstey/XML2JSON.jl.svg?branch=master)](https://travis-ci.org/paulstey/XML2JSON.jl)
