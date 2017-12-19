.. _tutorial_setup_score:

Initialize score
================

Let's start by initializing our application using the command line:

>>> from score.init import init
>>> app1 = init({'score.init': {'modules': 'moswblog'}})
>>> app1.moswblog.government_grant
348000000
>>> app2 = init({'score.init': {'modules': 'moswblog'},
...              'moswblog': {'government_grant': 0}})
>>> app2.moswblog.government_grant
0

We have just initialized two different instances of our app with different
configurations. The `dict` that we passed to :func:`score.init.init` contains
the list of modules to initialize followed by each module's configuration. This
is a terribly inconvenient way of initializing a module, and we will create a
configuration file to simplify this. Add the following to the file called
``dev.conf``:

.. code-block:: ini

    [score.init]
    modules =
        moswblog

    [moswblog]
    government_grant = 0

>>> from score.init import init_from_file
>>> configured_score = init_from_file('dev.conf')
>>> configured_score.moswblog.government_grant
0

The file contains the configuration for development systems and it will get
more interesting once we start adding other modules. It is time we start
defining the :ref:`ORM layer of moswblog <tutorial_db>`.
