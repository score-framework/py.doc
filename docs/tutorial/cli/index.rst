.. _tutorial_cli:

Command Line Interface
======================

When working with multiple people with different operating systems, editors and
workflows, it might become hard to make all your tools work on every
developer's machine. This where the :mod:`score.cli` module enters the stage:
The `command shell`_ is the lowest common denominator across all development
setups.

Whenever you encounter something you notice yourself doing more than a few
times, you might want to create a :term:`shell command` to avoid typing.
Remember: laziness is one of the `three great virtues of a programmer`_.

In the next few sections, we will write a shell command for destroying and
re-creating our database. This is quite a common operation during development,
since it would be a miracle if we got our database models right from the
beginning.

.. toctree::
    :maxdepth: 2

    configuration
    command

.. _command shell: https://en.wikipedia.org/wiki/Command-line_interface
.. _three great virtues of a programmer: http://threevirtues.com/

