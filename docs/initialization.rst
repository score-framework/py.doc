.. _initialization:

**************
Initialization
**************

As mentioned in the introduction, every SCORE application starts with an
initialization step. This page will describe a few of the details of the
initialization process, so make sure you have read and understood the basics
described in the :ref:`introduction` before proceeding.

The Entry Point
===============

The main function responsible for initializing your application is
:func:`score.init.init`. It accepts a nested dictionary, which is expected
to contain the configuration of each module. The easiest way of creating
such a nested configuration is through the function
:func:`score.init.parse_config_file`:

.. code-block:: python

    from score.init import init, parse_config_file
    score = init(parse_config_file(file))

There is another function, which does the above calls in a single step:
:func:`score.init.init_from_file`

.. code-block:: python

    from score.init import init_from_file
    score = init_from_file(file)

The Module List
===============

The first configuration, that is read from the initial configuration, is that
of :mod:`score.init` itself: The module needs to know, which other modules it
should initialize. It will extract the key ``conf['score.init']['modules']``
and construct a list of modules.

The next step is to create a dependency map to define the order, in which these
modules need to be initialized. Every module is assigned an :term:`alias
<module alias>` in this step, which is defined as part of the module name after
the last period. If the module is called ``transportation.aviation``, for
example, its alias will be ``aviation`` by default.

The modules will then be initialized through a call to their init function. The
:term:`confdict` passed as first parameter to this function is retrieved from
the initial configuration file under the alias of the module. The
``transportation.aviation`` module will be initialized like the following, for
example:

.. code-block:: python

    from transportation.aviation import init
    init(conf['baz'])

Aliasing Modules
================

Module aliases *must* be unique within a score initialization. But it is
possible to provide an explicit alias for each module. If you want the
``transportation.aviation`` module to be initialized as ``fleet``, for example,
you could write your configuration file like this:

.. code-block:: ini

    [score.init]
    modules = transportation.aviation:fleet

This makes it possible to initialize the same module multiple times, allowing
you to access the live database, as well as a legacy database, for example.

Since modules have dependencies, you might want to pass a dependency under a
different name if you change its alias. Here is an example initializing the
coconut module using the aviation module:

.. code-block:: ini

    [score.init]
    modules =
        transportation.aviation:fleet
        coconut(swallow=fleet)

Finalization
============

Since every module creates its own :class:`score.init.InitializedModule` class during the initialization, 

