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
the last period. If the module is called *transportation.aviation*, for
example, its alias will be *aviation* by default.

The modules will then be initialized through a call to their init function. The
:term:`confdict` passed as first parameter to this function is retrieved from
the initial configuration file under the alias of the module. The
*transportation.aviation* module will be initialized like the following, for
example:

.. code-block:: python

    from transportation.aviation import init
    init(conf['aviation'])


.. _module_alias:

Aliasing Modules
================

Module aliases *must* be unique within a score initialization. But it is
possible to provide an explicit alias for each module. If you want the
*transportation.aviation* module to be initialized as *fleet*, for example,
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


.. _configuration_helper:

Configuration Helpers
=====================

Passing configuration values as strings is not always the most convenient (or
the most readable) method. There are scenarios where python code is the best
way of configuring modules. The :term:`http router <request router>` is a good
example, which uses decorators to define routes:

.. code-block:: python

    from score.http import RouterConfiguration

    router = RouterConfiguration()

    @router.route('home', '/')
    def home(ctx):
        return 'Hello World'


The ``RouterConfiguration`` in this scenario is called :term:`configuration
helper` and helps keep the configuration readable. That configuration helper is
referenced in the confdict of the :mod:`score.http` module in a way, that can
be interpreted by func:`score.init.parse_object` and will be used during the
initialisation to compile the actual router.

The important bit here is that this helper object is in no way to be regarded
as property of any module, meaning that modules making use of such
configuration objects must not alter these objects during their initialization.
This definition allows reusing these objects across multiple module
instantiations; i.e. it is possible to initialize the :mod:`score.http` module
twice using the same configuration helper, and neither instance will interfere
with the other.


.. _finalization:

Finalization
============

Every module creates its own :class:`score.init.InitializedModule` class
during the initialization and updates the return values of other initialized
modules. The :mod:`score.css` module, for example, will register some routes at
the :mod:`score.http` module, in order to serve css assets.

Since some of the InitializedModules were modified after the initial call to
the module's ``init``, the finalization step will give them a chance to process
these changes before starting the actual application logic.

For this finalization step, all InitializedModule objects may implement a
method called ``_finalize``, accepting any number module names. This
module-list-as-function-arguments declares this modules dependencies for this
step only.

In the following example, the *coconut* module requires a *swallow* module
during the call to its ``init``, but will wait until the *knights* module is
finalized, before finalizing itself: 

.. code-block:: python

    from score.init import InitializedModule

    def init(confdict, swallow, knights=None):
        # TODO: do some real initialization here
        return InitializedCoconutModule(swallow, knights)

    class InitializedCoconutModule(InitializedModule):

        def __init__(self, swallow, knights):
            import coconut
            super().__init__(coconut)
            self.swallow = swallow
            self.knights = knights

        def _finalize(self, knights):
            knights.notify_topic(self)
