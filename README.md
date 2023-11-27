# lispylangs

write any language in lisp.

because lisp is good.

(currently implemented: html (basic support), current priority: html
attributes, css)

## terminology

for the rest of this document "$ll" will refer to the lispylangs root
directory.

## html

<details><summary>files</summary>

<details><summary>`$ll/html/html.lisp`</summary>

### `html`

converts lisp forms to html.

`(html used-tags forms)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-tags` | unevaluated list | list of used tag names | `("head" "body" "div")` or `html-all-tags` |
| `forms` | implicit progn | the content to convert | `(body (div "text"))` |
| | string | return value | `"<body><div>text</div></body>"` |

### `html-tag`

creates a tag. must be within an `html`, but that `html` doesn't need
to have the tag that's used by `html-tag`.

`(html-tag tag-name &optional options &rest body)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `tag-name` | string | name of the used tag | `"div"` |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

### [tag name]

creates a tag with `html-tag`. must be within an `html` who's
`used-tags` contains the string "[tag name]". (this works for all
tags, replacing [tag name] with the actual name of the tag.

`([tag-name] &optional options &rest body)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

</details>

<details><summary>`$ll/html/attributes/attributes.lisp` (not done yet)</summary>

### `attributes`

converts lisp forms to html attributes.

best used directly within or directly above `html`, but can be used
more specifically as well.

`(html-attributes used-attributes forms)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-attributes` | unevaluated list | list of used attribute names | `("style" "width" "height")` or `html-all-attributes` |
| `forms` | implicit progn | the content containing attribute forms | `(div (list (style "width: 10%")) text)` |
| | string | return value | `"style=\"width: 10%\""` |

### `html-attribute`

creates an attribute from either a pair of strings or a 2-element
list.

`(html-attribute name &optional value)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `name` | string or 2-element list | attribute name or list containing both name and value | `"width"` / `(list "width" "10%")` |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |

### [attribute name]

creates a tag with `attribute`. must be within an `html-attributes` who's
`used-attributes` contains the string "[attribute name]". (this works for all
attributes, replacing [attribute name] with the actual name of the attribute.

`([attribute name] value)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |

</details>

</details>

