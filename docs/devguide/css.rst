.. _devguide_css:

CSS Development Guide
=====================

Style Guide
-----------

Our style guide is based on the `OOCSS code standards`_. The rest of this
section only describes our deviations from said standard.

.. _OOCSS code standards: https://github.com/stubbornella/oocss-code-standards

Class Names
```````````

We prefer using dashes as separators in class names::

    /* Good - Use dashes */
    .this-is-good {}

    /* Bad - don't use underscores */
    .this_is_bad {}

    /* Bad - don't use camel case */
    .thisIsBad {}


Class names should describe their content, *not* the styles they apply::

    /* Good - describe the content */
    .breaking-news {
        background: blue;
    }
    .success-message {
        color: green;
    }

    /* Bad - don't describe the position of the box, */
    /* it could be on the right side in a later version */
    .left {
        background: green;
        float: left;
    }

    /* Bad - don't describe the looks of the box */
    .blue-bg {
        background: blue;
    }

Browser Sniffing
````````````````

Browser specific styles should be in separate per-browser stylesheets. Use
conditional comments to address specific browsers::

    /* Good - use conditional comments */
    <!--[if lt IE 7]>IE lower than version 7<!--<![endif]-->

    /* Bad - Hacks in main css File */
    .stubbornella {
        margin: 0;
        _margin: -1px;
    }

    /* Bad - uses selector hacks */
    .stubbornella {
        margin: 0px;
    }
    .ie6 .stubbornella {
        margin: -1px;
    }

Metadata
````````

Place a comment on the same line as the CSS declaration it's related to.
Also, add file-level comments at the top of every CSS file, describing the
file and its maintainer. The *minimum* such a comment should contain is
the following::

    /**
     * Description of the file.
     * @maintainer  Firstname Lastname <name@maintainer.com>
     */

There should be only *one* maintainer. This should be the person that can
answer any questions regarding this file. If there is another person, who
could answer any questions, add that person as a ``co-maintainer``.

If the file is intended for a short-lived feature (as is the case with many
things in the media business — just think of election pages, catastrophe
descriptions or dedicated layouts for social events), add an ``end-of-life``
in the format ``YYYY-MM-DD`` to the file::

    /**
     * Elections 2046.
     * @maintainer Some Body <sirlancelot@example.com>
     * @end-of-life 2046-12-31
     */


Resource locations
------------------

CSS and SCSS declarations must reside in dedicated CSS files in general. There
are a few exceptions to this rule, mentioned in the subsection about
:ref:`inline styles <css_inline_styles>`, below.

When working on the design of a new project, one should create dedicated CSS
(or SCSS) files for various parts of the design. There should be a file for
each "unit of work" conducted, and there should be as few files as necessary
that a newly-introduced maintainer could guess which file includes the
definitions of an element.

It should be clear which files need to be changed/deleted whenever an existing
feature is updated or removed.


Pre-Loading
```````````

Projects that require a *lot* of CSS declarations should consider pre-loading
declarations for elements "above the fold" :ref:`inline <css_html_function>`,
as `suggested by google`__. Example::

    <html>
        <head>
            {{ css('banner.css', inline=True) }}
        </head>
        <body>
            <h1> ... </h1>
            <div class="banner"> ... </div>
            <div class="other-content"> ... </div>
            {{ css_via_js() }}
        </body>
    </html>

The preferred way of implementing the pre-loading is via :term:`asset groups
<asset group>`. Our css module can automatically create such groups during its
:func:`initializaton <score.css.init>`.

This step should be performed as late as possible, though. It makes no sense
to start development with this exact differentiation in place, as the layout
is bound to change a lot during ongoing development.

.. todo::

    The function ``css_via_js`` does not exist yet. Its name is more a
    "working title", too.

.. _css_inline_styles:

Inline Styles
`````````````

There is just one scenario where writing CSS directly in HTML is preferable to
a dedicated file: When the styled object is

- highly localized (i.e. occurs only once),
- needs very few styles (i.e. less than ~50 lines) and
- is expected to be removed in the near future.

This might sound a bit restrictive, but exactly these are usually the
modifications performed on media websites. Real-world events that are bound to
expire by nature (big news, for example, like elections, catastrophes or
sports events) require the site to be modified for a short time.

These modifications can then be removed at a later point in HTML and CSS. If
those modifications were in different files, the CSS part might easily be
forgotten and would cause unnecessary bloat over time.


.. _score_sass:

SASS
----

SASS_ is a stylesheet language that compiles to CSS. It has `several
benefits`_ over using plain CSS, like functions or definition nesting.

SASS comes with two separate syntax definitions:

- ``scss``: A schema that tries to look very much like CSS.
- ``sass``: An `alternative syntax`_ similar to that of yaml_ or python_:
  indentation is part of the syntax and lines do not need a terminating
  semicolon.

We are using the original ``scss`` syntax, as it is easier to work with if
one is already accustomed to working with CSS.


Compass
```````

In our projects, we further make use of the excellent compass framework.
Compass_ is a set of pre-defined functions for SASS, which

- automate repetitive tasks in css (like prefixing declaration with
  browser-specific extensions) and
- provide solutions to various `browser bugs`_.

.. _SASS: http://sass-lang.com/
.. _several benefits: http://sass-lang.com/documentation/file.SASS_REFERENCE.html#features
.. _yaml: http://yaml.org/
.. _python: http://docs.python.org
.. _alternative syntax: http://sass-lang.com/documentation/file.INDENTED_SYNTAX.html
.. _Compass: http://compass-style.org/
.. _browser bugs: http://www.positioniseverything.net/explorer/doubled-margin.html

__ https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery

