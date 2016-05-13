
# xml2json
[![Build Status](https://travis-ci.org/bcbi/xml2json.jl.svg?branch=master)](https://travis-ci.org/bcbi/xml2json.jl)

### Installation
```{Julia}
Pkg.clone("https://github.com/bcbi/xml2json.jl.git")
```

This package implements a fairly simplistic XML-to-JSON conversion. Note that at this time the XML's attributes are ignored in the parsing. Any information kept here will not be preserved in the resulting JSON.

Given the root of an XML, the `xml2json()` function generates an `ASCIIString` with the appropriate formatting for JSON. We can then write this to disk.



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
using xml2json

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

This produces a the following:
```{JSON}
{
"bookstore":

    {
    "book":[
        {
        "author":["David Smith","James Jones"],
        "price":30.0,
        "year":2005,
        "title":"Biography of John Adams"
        },
        {
        "author":"Samantha Black",
        "price":29.99,
        "year":2005,
        "title":"Introduction to Templates in C++"
        }
    ],
    "owner":
        {
        "name":"Henry",
        "age":59,
        "address":
            {
            "zip":12345,
            "street":"123 Jones Avenue",
            "state":"CA"
            }
        }
    }
}
```

### Write JSON to Disk
Finally, we can simply print that string to disk using Julia's standard `write()` function.
```{Julia}
f = open("ex1.json", "w")
write(f, json_string)
close(f)
```

### Spacing and Newline Characters
Note that the `xml2json()` function takes two optional arguments. The first controls the spacing of the indentation in the resulting JSON. This defaults to 4 (some prefer 8). The second optional argument (and therefore, third positional argument) controls how newline characters are handled. By default, this replaces `\n` with `\\n` in the JSON's text fields. This produces valid JSON documents.


### _Caveats_
This package is under active development. Please notify us of bugs or proposed improvements by submitting an issue or pull request.
