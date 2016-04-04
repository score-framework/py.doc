.. _tutorial_db:

Database
========

The database requires a so-called :term:`base class` to work with. Fortunately,
creating one is as easy as calling a single function. Let's create the
necessary folders and files for our database package. The first folder is
``blog/db``, which will contain our database models:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ mkdir db

We will need to make this folder a python package by adding the file
``blog/db/__init__.py``. Usually it is completely sufficient to have an empty
file, as indicator for python that the folder is a python package. But we are
going to add an additional line to import everything from all sub-modules:

.. code-block:: python

    from score.init import import_from_submodules

    import_from_submodules()

This will allow us to access all models from all files in this folder under the
package *blog.db*. If this sounds confusing, don't worry: it will make a bit
more sense once we have some classes. So let's move on to creating our base
class.

Put the following into ``blog/db/storable.py``:

.. code-block:: python

    from score.db import create_base

    Storable = create_base()

We can now use this base class to create and inspect our database step by step:

.. toctree::
    :maxdepth: 2

    models
    conf
    reset

