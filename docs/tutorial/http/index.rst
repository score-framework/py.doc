.. _tutorial_http:

HTTP Server
===========

In this section, we will be using two modules to implement a very simple web
server. One of them is :mod:`score.http`, which is responsible for handling
HTTP requests and routing them through your application, while the other one is
:mod:`score.server`, the module that will start th actual HTTP server and keep
it running.

As always, let's start by defining a module to contain all relevant functions:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ mkdir blog/http

Like the *blog.db* package, we will auto-import everything from submodules in
``blog/http/__init__.py``:

.. code-block:: python

    from score.init import import_from_submodules

    import_from_submodules()

As with the database and the CLI, we will add this new feature step by step:

.. toctree::
    :maxdepth: 2

    configuration
    serve
    home
    article
    linking
