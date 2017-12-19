.. _tutorial_db_conf:

Database Configuration
----------------------

Before we can actually do anything with our models, we will need to tell the
:mod:`score.sa.db` module where the database is. For this tutorial, we will be
using sqlite_ (a database engine that operates on a single file).

Update your SCORE configuration file ``dev.conf``:

.. code-block:: ini
    :emphasize-lines: 4-5,9-15

    [score.init]
    modules =
        moswblog
        score.sa.db
        score.sa.orm

    [moswblog]
    government_grant = 0

    [db]
    sqlalchemy.url = sqlite:///${here}/database.sqlite3
    destroyable = true

    [orm]
    base = moswblog.db.Storable

Note, that the database module refuses to perform destructive operations on a
database, unless explicitly configured to be *destroyable*. We have set this
flag to be able to quickly destroy and re-create the database during
development.

We will also need to list these new python packages we will be using in our
application. Edit the file *setup.py* and add the following list of
dependencies to the section `install_requires`:

.. code-block:: python
    :emphasize-lines: 3-7

    install_requires=[
        'score.init',
        'score.sa.db',
        'score.sa.orm',
        'sqlalchemy_utils',
        'passlib',
        'PyYAML',
    ],

Install these new dependencies with *pip*:

.. code-block:: console

    $ pip install -e .

Now it's time to :ref:`reset the configured database and inspect the resulting
database <tutorial_db_reset>`.

.. _sqlite: https://sqlite.org/about.html
