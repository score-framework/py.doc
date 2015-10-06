.. _devguide_js:

Javascript Development Guide
============================

.. _js_coding_standards:

Style Guide
-----------

Naming
``````

- All our source code and its comments must be in english.
- Entities must have concise names, describing their *content*, if possible,
  and their *intended use*, if the *content* description would not add to the
  readability of the code.
- CamelCasing for compound names.
- Names should not be re-used within the same scope.
- Variable und function names start in lower-case.
- Class names start in upper-case.
- Constants are written in all upper case, where words are separated by
  underscores

Examples::

    var variableName = 12;
    var functionName = function() {
    };
    var CONSTANT_NAME = 14;
    var ClassName = oop.Class({
    });


Vertical Whitespace (i.e. Blank Lines)
``````````````````````````````````````

- No more than one blank line at once.
- Single blank line between functions.
- No blank lines *within* functions! If one feels the need to separate code
  blocks from each other, it is desirable to do so using comments describing
  the difference between the two blocks.
- Exception: Surrounding functions that serve a different purpose than to
  create a reusable code block are to be treated like a code block. Examples
  are:

  - Functions of ``define``-declarations::

        define('moduleName', ['requirements'], function(requirements) {

            var f = function() {
                // no vertical space in here
            };

            // vertical space here is ok here, as the function receiving the
            // requirements is to be regarded as the scope of a code block.

        });

  - Scope-generating functions::

        (function() {
            // whitespace here is ok, except if this construct is used within
            // a normal function.
        })();

Horizontal Whitespace
`````````````````````

- Horizontal whitespace always consists of space characters (ASCII code 0x20).
- Indentation is to be performed with four spaces.
- A single space character …

  - between keywords (``if``, ``while``, ``do``, ``for``, ``function``) and
    their corresponding opening parantheses,
  - after a comma,
  - around binary operators (``+``, ``-``, ``*``, ``/``, ``=``, ``+=``,
    ``==``, ``!=``, ``===``, ``!==``, ``instanceof``, …),
  - after comment slashes and
  - after type casts.

- *No* whitespace …

  - after unary operators except ``typeof`` (``!``, ``~``, ``+``, ``-``) or
  - between name and parameter list when invoking a function.

Statements
``````````

- Single statement per code line: ``thisIs(); notAllowed();``
- Every statement must be terminated by a semicolon.

Variables
`````````

- Just one variable per ``var`` declaration.
- Prefer declaring variables wherever they're used, not at the start of a
  scope. The performance penalty is more than negligable in almost all cases.
- Functions are to be declared like variables (``var f = function() { …``).
- Variables containing jQuery objects are to be prefixed with a dollar sign.
- Prefer type-safe comparisons (``===``, ``!==``) over operators with implicit
  type conversions (``==``, ``!=``).
- Test ``undefined`` via ``typeof``: ``if (typeof x === 'undefined') { …``

Classes
```````

- Use :ref:`our oop library <js_oop>` for declaring classes.
- If the class manages a DOM-Node, the variable containing that node must
  either be called ``$node`` or ``node``, depending on whether jQuery is in
  use.

.. _js_amd:

AMD
---

In order to manage the complexity of large javascript code bases, we are using
`asynchronous module definitions`__. The github repository of the amdjs group
contains a short `introduction to AMD`_.

The library we use for implementing AMD is require.js_.

.. _introduction to AMD: https://github.com/amdjs/amdjs-api/wiki/AMD
__ http://en.wikipedia.org/wiki/Asynchronous_module_definition
.. _require.js: http://requirejs.org/

Custom Conventions
``````````````````

Our usage of AMD differs from the more general concepts in the above
documents, though. In order to maintain uniformity across our projects, we
choose to give our libraries concise module names from the start. All external
libraries, even those of the *score* framework [1]_, are placed in a javascript
folder called *lib*. The module definition is altered on installation to
reflect the module's path. The :ref:`promises <js_promises>` library we use is
thus named *lib/bluebird* and is used as such in our project code::

    require(['lib/bluebird'], function(Promise) {
        // …
    });

The only exception to this is jQuery, which is kept with its default module
name `jquery`.

.. _js_promises:

Promises
--------

We are making strong use of promises_ during javascript development. Although
there is a standard for promises in `ECMAScript 6`_, we are using the promises
library bluebird_ for supporting browsers without an implementation for ES6
promises and for easier debugging of our code.

.. _promises: https://www.promisejs.org/
.. _ECMAScript 6: https://en.wikipedia.org/wiki/ES6
.. _bluebird: https://github.com/petkaantonov/bluebird

Footnotes
---------

.. [1] Although the libraries of the *score* framework are grouped into a
       sub-directory. Our :ref:`oop module <js_oop>` is called
       ``lib/score/oop``, for example.  Other library bundles — like
       *jquery.ui* —  are grouped like that, as well.

