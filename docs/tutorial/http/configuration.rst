.. _tutorial_http_conf:

HTTP Configuration
------------------

This time, we will only add :mod:`score.http` to the list of module to
initialize, but still configure the other module. In other words:
:mod:`score.serve` is not part of our blogging application, it is just a
*helper*: it will serve our application during development. We might choose a
different method in production (and most probably will).

Time to edit the configuration file ``local.conf``:

.. code-block:: ini
    :emphasize-lines: 6,13-14,16-18

    [score.init]
    modules = 
        score.shell
        score.db
        score.ctx
        score.http

    [db]
    base = blog.db.Storable
    sqlalchemy.url = sqlite:///${here}/database.sqlite3
    destroyable = true

    [http]
    router = blog.http.router

    [serve]
    modules = http
    autoreload = true

We need these modules installed, too, so let's edit our ``setup.py``:

.. code-block:: python
    :emphasize-lines: 7,8,12

    install_requires=[
        'score.init',
        'score.shell',
        'score.db',
        'score.ctx',
        'score.cli',
        'score.http',
        'score.serve',
        'sqlalchemy_utils',
        'passlib',
        'PyYAML',
        'docutils',
    ],

Again, we will have to re-install our package after changing its *setup.py*:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ python setup.py develop

In order to be able to define routes, we will need a :term:`configuration
helper`, that will hold the router configuration until the :mod:`score.http`
module is initialized. We will define this helper in the file
``blog/http/router.py``:

.. code-block:: python

    from score.http import RouterConfiguration

    router = RouterConfiguration()


Since everything is in place now, we can start the :ref:`http server
<tutorial_http_serve>`.


.. _sqlite: https://sqlite.org/about.html
.. _entry point: http://pythonhosted.org/setuptools/pkg_resources.html#entry-points
