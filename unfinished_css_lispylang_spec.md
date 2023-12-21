# lispylangs

write any language in lisp.

because lisp is good.

(currently implemented: html (tags and attributes), current priority: css)

## terminology

for the rest of this document "$ll" will refer to the lispylangs root
directory.

<details><summary><h2>html</h2></summary>

<details><summary><code>$ll/html/html.lisp</code></summary>

### `html`

converts lisp forms to html.

creates a scope defining the functions `html-tag` and `[tag name]` (for
tag names in `used-tags`).

`(html used-tags forms)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-tags` | unevaluated list | list of used tag names | `("head" "body" "div")` or `html-all-tags` |
| `forms` | implicit progn | the content to convert | `(body (div "text"))` |
| | string | return value | `"<body><div>text</div></body>"` |

### `html-tag`

creates an html tag.

only defined within an `html` block.

`tag-name` doesn't have to be contained within its parent `html`'s `used-tags`.

`(html-tag tag-name &optional options &rest body)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `tag-name` | string | name of the used tag | `"div"` |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

### `[tag name]`

creates a tag with `html-tag`.

only defined within an `html` block.

`"[tag name]"` must be within its parent `html`'s `used-tags`.

`([tag-name] &optional options &rest body)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `options` | list | the attributes of the tag | `(list "width=\"10%\"" "height=\"5%\"")` |
| `body` | implicit progn | the content within the tag | `"text" (div "more text")` |
| | string | return value | `"<div width=\"10%\" height=\"5%\">text<div>more text</div></div>"` |

#### example

`(div (list "width=\"10%\"") "text")` (assumed to be within `(html
("div" [...]) ...)`)

returns

`"<div width=\"10%\">text</div>"`

</details>

<details><summary><code>$ll/html/attributes/attributes.lisp</code></summary>

### `attributes`

creates a scope defining the functions `html-attribute` and `[attribute name]` (for
attribute names in `used-attributes`).

best used directly within an `html` block.

`(attributes used-attributes forms)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `used-attributes` | unevaluated list | list of used attribute names | `("style" "width" "height")` or `html-all-attributes` |
| `forms` | implicit progn | the content containing attribute forms | `(div (list (style "width: 10%")) text)` |
| | string | return value | `"style=\"width: 10%\""` |

### `html-attribute`

creates an attribute from either a pair of strings or a 2-element
list.

only defined within an `attributes` block.

`(html-attribute name &optional value)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `name` | string or 2-element list | attribute name or list containing both name and value | `"width"` / `(list "width" "10%")` |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |

### `[attribute name]`

creates a attribute with `html-attribute`.

only defined within an `attributes` block.

`"[attribute name]"` must be within its parent `attributes`'s `used-attributes`.

`([attribute name] value)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `value` | string | attribute value | `"10%"` |
| | string | return value | `"width=\"10%\""` |

</details>

</details>

<details><summary><h2>css</h2></summary>

<details><summary><code>$ll/css/css-block.lisp</code></summary>

### `css-block`

delimits a block of css.

best used with `css-select` (`$ll/css/css-select.lisp`).

`(css-block selector properties)`

#### arguments

| name | type | description | example |
| ---- | ---- | ----------- | ------- |
| `selector` | string | css selector | `".class > div"` |
| `properties` | unevaluated list | css properties | `("width: 10%;" "height: 5%")` |
| | string | return value | `".class > div {width: 10%; height: 5%;}"` |

</details>

<details><summary><code>$ll/css/css-select.lisp</code></summary>

### `css-select`

creates a scope defining css selector functions. (specifically, all
the functions in this documentation block)

`(css-select selector)`

`selector` is equivalent to `css-block`'s `selector` argument.

### boolean selectors

#### `select-not`

NOTs the provided selector.

`(select-not selector)`

#### `select-or`

ORs selectors together.

`(select-or &rest selectors)`

##### example

`(select-or ".a .b" ".c > .a" ".c > .b")`

returns

`":is(.a .b, .c > .a, .c > .b)"`

#### `select-and`

ANDs selectors together.

`(select-and &rest selectors)`

arguments are selector strings, returns a selector string.

##### example

`(select-and ".a .b" ".c > .a" ".c > .b")`

returns

`":is(.a .b):is(.c > .a):is(.c > .b)"`

### comination selectors

#### `descend`

`(descend &rest selectors)`

separates `selectors` with direct descendant selectors.

##### example

`(descend ".a b" ".c > .a" ".c > .b")`

returns

`".a .b > .c > a > .c > .b"`

#### `descends`

separates `selectors` with indirect descendant selectors.

`(descends &rest selectors)`

##### example

`(descends ".a b" ".c > .a" ".c > .b")`

returns

`".a .b .c > a .c > .b"`

#### `after`

selects elements selected by `s-after` after `s-before`.

`(after s-before s-after)`

##### example

`(after ".a b" ".c > .a")`

returns

`":is(.a b) ~ :is(.c > .a)"`

#### `next`

selects elements selected by `s-next` immediately after `s-before`.

`(next s-before s-next)`

##### example

`(next ".a b" ".c > .a")`

returns

`":is(.a b) + :is(.c > .a)"`

#### `before`

(note: this is not standard css.)

selects elements selected by `s-before` that come before `s-after`.

`(before s-after s-before)`

##### example

`(before ".a b" ".c > .a")`

returns

`":is(.c > .a):not(:is(.a b) ~ :is(.c > .a))"`

#### `previous`

> [!CAUTION]
> THIS IS NOT IMPLEMENTED, AND PROBABLY NEVER WILL BE.

selects elements selected by `s-previous` that come immediately before `s-after`.

`(previous s-after s-previous)`

### attribute-based selectors

#### `attribute-exists`

selects all elements with a given attribute defined.

`(attribute-exists name)`

#### `attribute-equals`

selects all elements with a given attribute that equals `value`.

`(attribute-equals name value)`

#### `attribute-contains`

selects all elements with a given attribute that contains `value`.

if case-sensitivity is non-nil, comparison will be done case-sensitively.

`(attribute-contains name value &optional case-sensitivity)`

#### `attribute-starts-with`

selects all elements with a given attribute that starts with `value`.

`(attribute-starts-with name value)`

#### `attribute-ends-with`

selects all elements with a given attribute that ends with `value`.

`(attribute-ends-with name value)`

### simple selectors

#### `any`

selects any element.

`(any)`

#### `tag`

selects elements by tag name.

`(tag name)`

#### `class`

selects elements by class name.

`(class name)`

#### `id`

selects elements by id.

`(id name)`

### nth selectors

#### `nth-element`

selects the `n`th child element of `parent`.

`(nth-element n parent)`

#### `nth-last-element`

selects the `n`th-from-last child element of `parent`.

`(nth-last-element n parent)`

</details>

</details>
