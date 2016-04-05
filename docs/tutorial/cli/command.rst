.. _tutorial_cli_command:

Shell Command
-------------

We had declared in our package setup, that the function is called *main* and
resides in the module *blog.cli.db*. This means we will add the following to
the file ``blog/cli/db,py``:

.. code-block:: python

    import click
    from score.db import load_data


    @click.group()
    def main():
        """
        Provides database management commands.
        """


    @main.command()
    @click.pass_context
    def reset(click):
        """
        Drops and re-creates the database.
        """
        score = click.obj['conf'].load()
        with score.ctx.Context() as ctx:
            score.db.destroy()
            score.db.create()
            source = 'http://score-framework.org/doc/_downloads/moswblog.yaml'
            objects = load_data(source)
            for cls in objects:
                for id in objects[cls]:
                    ctx.db.add(objects[cls][id])

We have just created two functions: one `command group`_ called *main*, which
is just there to encapsulate further database command, that we might write in
the future. The other is a sub-command called *reset*, which will drop and
re-create our database.

Remember, that we have declared in our *setup.py*, that this entry point is to
be called *db*. That's why you can access the *main* function as ``score db``:

.. code-block:: console

    (moswblog)soulmerge@ca:~/tmp/moswblog$ score db
    Usage: score db [OPTIONS] COMMAND [ARGS]...

      Provides database management commands.

    Options:
      --help  Show this message and exit.

    Commands:
      reset  Drops and re-creates the database

This is the aforementioned command group. If you want to call the other *reset*
function, just append it to the command line:

.. code-block:: console

    (moswblog)soulmerge@ca:~/tmp/moswblog$ score db reset

Congratulations! You have just written and executed a shell command! We can
leave the shell for now and implement another way of accessing our database: a
:ref:`web application <tutorial_http>`.

.. _command group: http://click.pocoo.org/5/commands/
