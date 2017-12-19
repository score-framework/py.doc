.. _tutorial_http:

HTTP Server
===========

In this section, we will be using two modules to implement a very simple web
server. One of them is :mod:`score.http`, which is responsible for handling
HTTP requests and routing them through your application, while the other one is
:mod:`score.serve`, the module that will start the actual HTTP server and keep
it running.

As with the database and the CLI, we will add this new feature step by step:

.. toctree::
    :maxdepth: 2

    configuration
    serve
    home
    article
    linking
