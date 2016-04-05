.. _tutorial_http_home:

Home Page
---------

The router configuration object we created earlier provides a convenient
decorator for defining new routes. Let's make use of that and add our first
route to ``blog/http/home.py``:

.. code-block:: python

    from .router import router

    @router.route('home', '/')
    def home(ctx):
        return 'Hello, World!'

This will define a route called *home*, which is available under the root path,
i.e. this route is responsible for your home page. Try visiting
http://localhost:8080 again and you should see your first route's enthusiastic
greeting.

But since nobody is called "World", we should change the route to be able to
provide a proper name:

.. code-block:: python

    from .router import router

    @router.route('home', '/{name}')
    def home(ctx, name):
        if not name:
            name = 'World'
        return 'Hello, %s!' % name

Visiting http://localhost:8080/SirLancelot will now greet us with our title and
name. We will gracefully ignore the application's lack of sensibility when it
comes to addressing aristocracy properly.

As you can see, the URL template now happily accepts *every* URL and returns a
greeting for the given string. This is achieved through a variable in the URL
template, and we will soon make use of this to access our articles. But let's
first change the route to list the articles in our database instead:

.. code-block:: python

    from .router import router
    import blog.db as db

    @router.route('home', '/')
    def home(ctx):
        html = ''
        for article in ctx.db.query(db.Article):
            html += article.title
            html += '<br>'
        return html

Alright, this is a bit more interesting, but we still can't see the contents of
the aricles. The next step would be to create the :ref:`article route
<tutorial_http_article>`.
