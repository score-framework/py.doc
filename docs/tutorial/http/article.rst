.. _tutorial_http_article:

Article Route
-------------

We will now create a route to display our articles. Here is the basic route,
that we will expand shortly:

.. code-block:: python

    from .router import router
    import blog.db as db

    @router.route('article', '/{article.id}')
    def article(ctx, article: db.Article):
        return article.title

This route still does not provide any more information than the home page, but
at least we have a URL now! You can visit http://localhost:8080/article/1, for
example, to read the title of the first article.

There are several things of interest here. The most important observation is
that the route function receives an ``Article`` object, and not an id! The
underlying philosophy during route definition is: Always try to write your
route functions just like regular functions! If you had a function for
lower-casing an article's text, you wouldn't pass it an article id, either.

But the the question is: why do we receive an ``Article`` object? The reason is
simple: The http module accepts :mod:`score.db` as optional dependency during
its initialization and thus detects route variables that can be retrieved from
the database. This won't work in *every* case, but is good enough for most
routes.

Alright, let's make the output of this route a bit prettier:

.. code-block:: python

    from .router import router
    import blog.db as db
    from docutils.core import publish_parts


    @router.route('article', '/article/{article.id}')
    def article(ctx, article: db.Article):
        body = publish_parts(article.body, writer_name='html')['body']
        return '''
            <div style="max-width:800px">
                <h1 style="font-size:2em">%s</h1>
                <div style="font-size:1.5em">%s</div>
                <div>%s</div>
            </div>
        ''' % (article.title, article.teaser, body)

You can now finally read the whole body of the first article at the URL
http://localhost:8080/article/1.

We should now :ref:`revisit the home page <tutorial_http_linking>` and
add links to the routes.
