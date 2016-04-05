.. _tutorial_cli_conf:

CLI Configuration
-----------------

We will update our SCORE configuration file ``local.conf`` to integrate some
new modules:

.. code-block:: ini
    :emphasize-lines: 5,6

    [score.init]
    modules = 
        score.shell
        score.db
        score.ctx
        score.cli

    [db]
    base = blog.db.Storable
    sqlalchemy.url = sqlite:///${here}/database.sqlite3
    destroyable = true

These modules need to be installed, too, so let's add them to our ``setup.py``:

.. code-block:: python
    :emphasize-lines: 5,6

    install_requires=[
        'score.init',
        'score.shell',
        'score.db',
        'score.ctx',
        'score.cli',
        'sqlalchemy_utils',
        'passlib',
        'PyYAML',
    ],

We will need to add something else to the same file: the `entry point`_
definition. The next line might look a bit complicated, if you are new to this
concept, but it basically just says:

    If some code asks for objects belonging to the *score.cli* group, make
    sure to include the function *main*, too. You can find it in the package
    *blog.cli.db*. Oh, and tell her this rule is called *db*.

.. code-block:: python

    install_requires=[
        ...
    ],
    entry_points={
        'score.cli': [
            'db = blog.cli.db:main',
        ],
    },

Since we have changed some definitions in our package, we will have to
re-install it:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ python setup.py develop

It is now time to write the function we referenced earlier. This will be our
:ref:`first shell command <tutorial_cli_command>`.

.. _sqlite: https://sqlite.org/about.html
.. _entry point: http://pythonhosted.org/setuptools/pkg_resources.html#entry-points
