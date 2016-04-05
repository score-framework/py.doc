.. _tutorial_db_conf:

Database Configuration
----------------------

Before we can actually do anything with our models, we will first need to teach
the :mod:`score.db` module where the database is. For this tutorial, we will be
using sqlite_, which is a database engine that operates on a single file.

Let's update our SCORE configuration file ``local.conf``:

.. code-block:: ini

    [score.init]
    modules = 
        score.shell
        score.db

    [db]
    base = blog.db.Storable
    sqlalchemy.url = sqlite:///${here}/database.sqlite3
    destroyable = true

Note, that the database module refuses to perform destructive operations on a
database, unless explicitly configured to be *destroyable*. We will set this
flag to be able to quickly destroy and re-create the database.

We will also need to list some packages we will be using in our application.
Edit the file *setup.py* and add the following list of dependencies to the
section `install_requires`:

.. code-block:: python

    install_requires=[
        'score.init',
        'score.shell',
        'score.db',
        'sqlalchemy_utils',
        'passlib',
        'PyYAML',
    ],

Installing the dependencies is done with the following command:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ python setup.py develop

Now it's time to :ref:`reset the configured database and inspect the resulting
database <tutorial_db_reset>`.

.. _sqlite: https://sqlite.org/about.html
