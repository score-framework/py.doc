.. _tutorial_setup_module:

Create Python Module
====================

As described earlier, we will need a python module that adheres to the
:ref:`SCORE module guidelines <tutorial_initialization>`. If you skipped that
part, you should really read it now.

The python package shall be called moswblog (as an acronym for "Ministry Of
Silly Walks Blog"). In order be able to install this package into our virtual
environment, we will need a `setup script`_. Create the file ``setup.py`` with
the following content:

.. code-block:: python

  from setuptools import setup

  setup(
      name='moswblog',  # the name of our python package
      install_requires=[
          'score.init',
      ],
  )


The python package itself will start out as a folder with a single file. We
will expand our module as we progress. Create a folder called ``moswblog`` (the
`python package folder`_) and add the file ``moswblog/__init__.py`` with the
following content:

.. code-block:: python

  from score.init import ConfiguredModule


  def init(confdict):
      government_grant = int(confdict.get('government_grant', 348 * 10**6))
      return Moswblog(government_grant)


  class Moswblog(ConfiguredModule):

      def __init__(self, government_grant):
          super().__init__('moswblog')  # name of this python package
          self.government_grant = government_grant

We now have a python package for our project, that can be initialized by
:mod:`score.init`. Before we do that, we will test the initialization manually.
We need to install our module into the virtual environment first:

.. code-block:: console

    $ pip install -e .

Now we can initialize the module. Let's perform two different tests: once with
the default government grant amount and once with a custom value:

>>> import moswblog
>>> blog = moswblog.init({})
>>> blog.government_grant
348000000
>>> blog = moswblog.init({'government_grant': 0})
>>> blog.government_grant
0

So far, this is nothing spectacular. Let's move on to the :ref:`SCORE
configuration of our project <tutorial_setup_score>` to understand why we
didn't just build a class accepting the *government_grant* value as a
parameter.

.. _python package folder: https://docs.python.org/3/tutorial/modules.html#packages
.. _setup script: https://docs.python.org/3.6/distutils/setupscript.html#writing-the-setup-script
