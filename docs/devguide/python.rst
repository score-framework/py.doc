.. _devguide_python:

Python Development Guide
========================

Style Guide
-----------

Fortunately, python is a language with a good style guide defined in its
PEP8_. We are mostly adhering to that standard, but have a more lax view on
line lengths: They *should* be less than 80 characters wide, but it is
possible to write longer lines — of up to 120 characters — **iff** it serves
readability.

.. _PEP8: https://www.python.org/dev/peps/pep-0008/

.. _module_initialization:

Module Initialization
---------------------

The behaviour of SCORE modules can usually be adjusted via configuration
variables. Since the whole framework is optimized for the implementation of web
projects, many modules provide a dedicated initialization function called
``init``, which verifies the provided configuration and initializes all
required resources. This function is called before the final application starts
accepting requests from browsers.

These ``init`` functions must accept a `dict` mapping string keys to their
configuration values. This input value is referred to as a :term:`confdict`
throughout the documentation. The ``init`` function will then create and return
an instance of a module-specific sub-class of the
:class:`score.init.ConfiguredModule` class, which provides all features of the
module that need to be configured before usage.

So if the module called ``score.sketch`` provides a configurable list of
actors, the :term:`confdict` might get extracted from the following
configuration::

    [score.sketch]
    available_actors =
        John Cleese
        Graham Chapman
        The Vikings
        Sir Lancelot

Initializing the module would then be as easy as calling its init function and
operate on its return value, a ConfiguredSketchModule instance:

>>> import configparser
>>> import score.sketch
>>> parser = configparser.ConfigParser()
>>> parser.read('configuration.ini')
>>> confdict = parser['score.sketch']
>>> sketch = score.sketch.init(confdict)
>>> assert isinstance(sketch, score.init.ConfiguredModule)
>>> assert isinstance(sketch, score.sketch.ConfiguredSketchModule)
>>> sketch.available_actors()
['John Cleese', 'Graham Chapman', 'The Vikings', 'Sir Lancelot']

If a module has dependencies to other modules, its ``init`` function will
accept further parameters where each parameter is called
``<dependency_name>_conf``.

If we were to write another module called ``score.parrot``, which depends on
``score.sketch``, we would need to add its configuration to our config file::

    [score.parrot]
    type = Norwegian Blue
    state = dead

The module's ``init`` function would now require two arguments: the usual
:term:`confdict` to use for the configuration and a ``sketch_conf``, which must
be an instance of ConfiguredSketchModule:

>>> import score.parrot
>>> parrot_confdict = parser['score.parrot']
>>> parrot_sketch = score.parrot.init(parrot_confdict, sketch)
>>> parrot_sketch.perform()

Since managing the initialization of many SCORE modules in this many is quite
cumbersome, there is another dedicated module called :mod:`score.init` for
automating this task.  Using its :func:`init <score.init.init>` function is the
preferred way of initializing SCORE applications.

.. _framework_integration:

Integration of other Frameworks
-------------------------------

.. note::
    Although the only external framework we are currently supporting is
    pyramid_, SCORE is written with other extensions in mind.

    .. _pyramid: http://docs.pylonsproject.org/projects/pyramid/en/latest/

If a SCORE module supports another framework, the module will have a package
dedicated for the integration of that framework. Most SCORE modules currently
have a ``pyramid`` package, which provides its own ``init``-function. Those
``init``-functions always take pyramid's :class:`Configurator
<pyramid.config.Configurator>` object as the second argument.

CLI Development Guide
---------------------

For development of command-line applications, we are using the formidable
click_ library. And since we strive to provide as many useful features through
the command line as possible, we have developed a dedicated module providing
many useful features to CLI application: :mod:`score.cli`

.. _click: http://click.pocoo.org/3/
