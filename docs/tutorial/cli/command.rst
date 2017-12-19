.. _tutorial_cli_command:

Shell Command
-------------

We will now create our own shell command that automatically destroys and
re-creates our database. We will expand the ``score`` command line by adding a
new command group called ``moswblog`` for all our shell commands and add our
first command called ``resetdb`` to this group. When we're done, we should be
able to invoke ``score moswblog resetdb`` to reset our application database.

Let's start by adding the following to the new file ``moswblog/cli.py``:

.. code-block:: python

    import click
    from score.sa.orm import load_data


    @click.group()
    def main():
        """
        Manages the Ministry Of Silly Walks Blog.
        """


    @main.command()
    @click.pass_context
    def resetdb(click):
        """
        Drops and re-creates the database.
        """
        score = click.obj['conf'].load()
        score.db.destroy()
        score.orm.create()
        session = score.orm.Session()
        source = 'http://score-framework.org/doc/_downloads/moswblog.yaml'
        objects = load_data(source)
        for cls in objects:
            for id in objects[cls]:
                session.add(objects[cls][id])
        session.commit()

We have just created two functions: a `command group`_ called *main*, which
will encapsulate all our application-specific commands, and a sub-command
called *resetdb*, which will drop and re-create our database.

We will now need to register these functions with :mod:`score.cli`. This is
done using `entry point`_ definitions. The next line might look a bit
complicated, if you are new to this concept, but it basically just says:

    If some code asks for objects belonging to the *score.cli* group, make
    sure to include the function *main*, too. You can find it in the package
    *moswblog.cli*. Oh, and tell the caller that this rule is called
    *moswblog*.

Open up the file ``setup.py`` and add the following to the setup configuration:

.. code-block:: python

    install_requires=[
        ...
    ],
    entry_points={
        'score.cli': [
            'moswblog = moswblog.cli:main',
        ],
    },

Remember, that we have declared in our *setup.py*, that this entry point is to
be called *moswblog*. That's why you can access the *main* function as ``score
moswblog``:

.. code-block:: console

    Usage: score moswblog [OPTIONS] COMMAND [ARGS]...

      Manages the Ministry Of Silly Walks Blog.

    Options:
      --help  Show this message and exit.

    Commands:
      resetdb  Drops and re-creates the database.

This is the aforementioned command group. If you want to call the other
*resetdb* function, just append it to the command line:

.. code-block:: console

    $ score moswblog resetdb

Congratulations! You have just written and executed a shell command! We can
leave the shell for now and implement another way of accessing our database:
:ref:`a simple web application <tutorial_http>`.

.. _command group: http://click.pocoo.org/5/commands/
.. _entry point: http://pythonhosted.org/setuptools/pkg_resources.html#entry-points
