.. _tutorial_http_linking:

Creating URLs
-------------

Let's go back to our home route to add links to the list of articles. Open up
``blog/http.py`` and modify the *home* function to look like the following:

.. code-block:: python

    @router.route('home', '/')
    def home(ctx):
        html = ''
        for article in ctx.orm.query(db.Article):
            url = ctx.url('article', article)
            html += '<a href="%s">%s</a><br>' % (url, article.title)
        return html

If you visit http://localhost:8080, you should now have a nice list of
articles, each with a hyperlink to the article page itself.

As you can see in the code, the :term:`context object` *ctx* provides a
function for creating URLs. This function is a so-called :term:`context
member`, and was registered automatically by the :mod:`score.http` module
during its initialization.

The most interesting part is the function signature: The route is again passed
the whole object, instead of an article id. This is merely the continuation of
the philosopy explained earlier: To create a URL to a route, pass it the exact
same arguments the function itself expects. The :mod:`score.http` module will
usually take care of all required conversions. You can read up on the details
of the routing in the module documentation.

Let's review what we have done in the :ref:`final chapter of the tutorial
<tutorial_conclusion>`.
