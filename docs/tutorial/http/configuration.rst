.. _tutorial_http_conf:

HTTP Configuration
------------------


In order to be able to define routes, we will need a :term:`configuration
helper` that will hold the router configuration until the :mod:`score.http`
module is initialized. We will define this helper in the file
``moswblog/http.py``:

.. code-block:: python

    from score.http import RouterConfiguration

    router = RouterConfiguration()


And now the configuration. Note, that we will only add :mod:`score.http` (and
its dependency :mod:`score.ctx`) to the list of modules to initialize. The
other module—:mod:`score.serve`—is not part of our blogging application, it is
just a helper: it will serve our application during development. We might even
choose a different method in production.

Edit the configuration file ``dev.conf``:

.. code-block:: ini
    :emphasize-lines: 6-7,11-16

    [score.init]
    modules = 
        moswblog
        score.sa.db
        score.sa.orm
        score.ctx
        score.http

    ...

    [http]
    router = moswblog.http.router

    [serve]
    modules = http
    autoreload = true

We need these modules installed, too, so let's add them to our ``setup.py``:

.. code-block:: python
    :emphasize-lines: 6-8,12

    install_requires=[
        'score.init',
        'score.sa.db',
        'score.sa.orm',
        'score.shell',
        'score.ctx',
        'score.http',
        'score.serve',
        'sqlalchemy_utils',
        'passlib',
        'PyYAML',
        'docutils',
    ],

Again, we will have to re-install our package after changing its dependencies:

.. code-block:: console

    $ pip install -e .

Since everything is in place now, we can :ref:`start the moswblog http server
<tutorial_http_serve>`.


.. _sqlite: https://sqlite.org/about.html
.. _entry point: http://pythonhosted.org/setuptools/pkg_resources.html#entry-points
