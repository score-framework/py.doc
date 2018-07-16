.. _tutorial_http_serve:

Starting Serve
--------------

Starting the server is as simple as calling the shell command of
:mod:`score.serve`:

.. code-block:: console

    $ score serve

That's it! You can now fire up your browser and visit http://localhost:8080 and
enjoy the glorious welcome page: a 404 error.

Wait ... What?

The error makes sense if you understand how routing works: The
:mod:`score.http` module will ask each registered route if it can handle the
current HTTP request. If none of them can, it emits a 404 to the client:
resource not found. Since we have not defined any routes yet, every call will
lead to the same result.

Let's change that and create the :ref:`home page route <tutorial_http_home>`.

.. note::

    You will need to leave this process running, to continue accessing your
    application via http.  
