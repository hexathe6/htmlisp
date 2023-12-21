# htmlisp

html as a format isn't very good. however, lisp is nice, especially
for densely nested things, so why not use it?

this is a lisp tool that converts 'htmlisp' forms to html. (you have
to write it to a file yourself though)

# `html.lisp`

## `html`

converts lisp forms to html.

creates a scope defining the functions `html-tag` and `[tag name]` (for
tag names in `used-tags`).

`(html used-tags forms)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-tags` | unevaluated list | list of used tag names | `("head" "body" "div")` or `html-all-tags` |
| `forms` | implicit progn | the content to convert | `(body (div "text"))` |
| | string | return value | `"<body><div>text</div></body>"` |

## `html-tag`

creates an html tag.

only defined within an `html` block.

`tag-name` doesn't have to be contained within its parent `html`'s `used-tags`.

`(html-tag tag-name &optional options &rest body)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `tag-name` | string | name of the used tag | `"div"` |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

## `[tag name]`

creates a tag with `html-tag`.

only defined within an `html` block.

`"[tag name]"` must be within its parent `html`'s `used-tags`.

`([tag-name] &optional options &rest body)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

### example

`(div (list "width=\"10%\"") "text")` (assumed to be within `(html
("div" [...]) ...)`)

returns

`"<div width=\"10%\">text</div>"`

# `attributes.lisp`

## `attributes`

creates a scope defining the functions `html-attribute` and `[attribute name]` (for
attribute names in `used-attributes`).

best used directly within an `html` block.

`(attributes used-attributes forms)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-attributes` | unevaluated list | list of used attribute names | `("style" "width" "height")` or `html-all-attributes` |
| `forms` | implicit progn | the content containing attribute forms | `(div (list (style "width: 10%")) text)` |
| | string | return value | `"style=\"width: 10%\""` |

## `html-attribute`

creates an attribute from either a pair of strings or a 2-element
list.

only defined within an `attributes` block.

`(html-attribute name &optional value)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `name` | string or 2-element list | attribute name or list containing both name and value | `"width"` / `(list "width" "10%")` |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |

## `[attribute name]`

creates a attribute with `html-attribute`.

only defined within an `attributes` block.

`"[attribute name]"` must be within its parent `attributes`'s `used-attributes`.

`([attribute name] value)`

### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |
