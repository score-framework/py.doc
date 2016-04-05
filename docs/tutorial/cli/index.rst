.. _tutorial_cli:

Command Line Interface
======================

When working with multiple people with different operating systems, editors and
workflows, it might become hard to make all your tools work on every
developer's machine. That's why we provide the :mod:`score.cli` module: The
`command shell`_ is the lowest common denominator across most development setups.

Whenever you encounter something you notice yourself doing more than a few
times, you might want to create a :term:`shell command` to avoid typing -
remember: laziness is one of the `three virtues of a programmer`_.

In the next few sections, we will write a shell command for destroying and
re-creating our database. This is quite a common operation during development,
since it would be a miracle if we got our database models right from the
beginning.

Just like with the  database, we need a folder containing all our shell
commands. Lets call it *blog.cli* for Command Line Interface:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ mkdir blog/cli
    (moswblog)sirlancelot@spamalot:~/moswblog$ touch blog/cli/__init__.py

Now we are ready to integrate the module and write our shell command.

.. toctree::
    :maxdepth: 2

    configuration
    command

.. _command shell: https://en.wikipedia.org/wiki/Command-line_interface
.. _three virtues of a programmer: http://threevirtues.com/

