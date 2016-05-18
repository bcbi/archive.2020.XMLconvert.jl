
# XMLconvert
[![Build Status](https://travis-ci.org/bcbi/XMLconvert.jl.svg?branch=master)](https://travis-ci.org/bcbi/XMLconvert.jl)

This package implements a few simple XML conversions. As of now, we can convert XMLs into nested `MultiDict` objects from the [DataStructures](https://github.com/JuliaLang/DataStructures.jl) package. We can also take an XML that has been converted to a         nested `MultiDict` and "flatten" the hierarchical structure into a non-nested `Dict`. Additionally, we can convert XMLs to JSONs using the nested `MultiDict` objects as an intermediary. Note that as of this writing, we drop the attributes of the XML.


### Setup
```{Julia}
Pkg.clone("https://github.com/bcbi/XMLconvert.jl.git")
```

### Examples
For our examples we consider the following simple XML document. This toy example was borrowed (with slight modification) from the [LightXML](https://github.com/JuliaLang/LightXML.jl) package.
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
using XMLconvert

filename = "ex1.xml"

# Read in XML and get its root
xdoc = parse_file(filename)
xroot = root(xdoc)

display(xroot)
```


Alternatively, when working with small XMLs, we can parse directly from a string rather than from the .xml file on disk. Note that we must escape out the quotation marks in the XML document.

```{Julia}
 # Note the need to escape out quotation marks
xmlstr = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<bookstore>
  <book>
    <title>Introduction to Templates in C++</title>
    <author>Samantha Black</author>
    <year>2005</year>
    <price>29.99</price>
  </book>
  <owner>
    <name>Henry</name>
  </owner>
</bookstore>
"
xdoc = parse_string(xmlstr)
```
</br>


### Converting XML to `MultiDict`
In many cases, it is desirable to convert an XML to a more native Julia object. This can be useful for unpacking elements of the XML and flattening out the structure of data. The `xml2dict()` function takes an XML's root (from above example) and converts the XML to a nested `MultiDict` object.
```{Julia}
# convert to MultiDict
mdict = xml2dict(xroot)
```
We can take a look at the structure of of the `MultiDict`.
```{Julia}
# print key structure of the MultiDict
show_key_structure(mdict)
```

```
-book
    -author
    -author
    -price
    -year
    -title
-book
    -author
    -price
    -year
    -title
-owner
    -name
    -age
    -address
        -zip
        -street
        -state
```
</br>

### Extracting Elements from `MultiDict`
Knowing the key structure of the XML we have parsed into a `MultiDict`, we can now access the elements much like we would using a standard `Dict` from Base Julia.

```{Julia}
mdict["book"][2]["title"][1]        # "Introduction to Templates in C++"
```
</br>

### Flattening Nested `MultiDict`
It is also frequently useful to take the hierarchical structure of an XML and "flatten" it to some data format with fewer dimensions. This makes accessing elements much simpler. This is implemented in the `flatten()` function, which when given a nested `MultiDict` object returns a single "flat" `Dict`.

```{Julia}
xdoc = parse_file(filename)
xroot = root(xdoc)
mdict = xml2dict(xroot)

fdict = flatten(mdict)
display(fdict)
```

```
Dict{Any,Any} with 9 entries:
  "book-price"           => Any[30.0,29.99]
  "book-author"          => Any["David Smith","James Jones","Samantha Black"]
  "book-year"            => Any[2005,2005]
  "owner-address-zip"    => Any[12345]
  "owner-address-street" => Any["123 Jones Avenue"]
  "owner-name"           => Any["Henry"]
  "owner-age"            => Any[59]
  "book-title"           => Any["Biography of John Adams","Introduction to Templa…
  "owner-address-state"  => Any["CA"]
```
As we can see above, this produces a single (non-nested) `Dict` where the keys are a string concatenation of the keys in the `MultiDict` corresponding to the hierarchical paths of their respective elements. And of course, the elements are simply the elements from the nested `MultiDict` (e.g., `Array`s of strings or numeric values).  

Although this kind of flattening is very often useful, we note that removing the original hierarchical structure loses some information. For example, as we see above the returned `Dict` no longer conveys the information about authorship of the two books in our example. The authors and books are both listed, but we can't say who wrote which book.

</br>

### Converting XML to JSON
If we wanted to convert the above XML to JSON we simply pass the parsed XML's root to the `xml2json()` function.
```{Julia}
xdoc = parse_file(filename)
xroot = root(xdoc)

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
</br>

### Write JSON to Disk
Finally, we can simply write that string to disk using Julia's standard `write()` function.
```{Julia}
f = open("ex1.json", "w")
write(f, json_string)
close(f)
```


</br>

### Spacing and Newline Characters
Note that the `xml2json()` function takes two optional arguments. The first controls the spacing of the indentation in the resulting JSON; this defaults to 4 (some prefer 8). The second optional argument (and therefore, third positional argument) controls how newline characters are handled. By default, this replaces `\n` with `\\n` in the JSON's text fields. This produces valid JSON documents.

</br>

### _Caveats_
This package is under active development. Please notify us of bugs or proposed improvements by submitting an issue or pull request.
