.. _tutorial_cli_conf:

CLI Configuration
-----------------

The module :mod:`score.cli` provides the executable *score* which can
initialize SCORE and to perform operations with the configured application.
Install it using pip:

.. code-block:: console

    $ pip install score.cli

And now you will need to register your development configuration with this
command:

.. code-block:: console

    $ score conf add dev.conf
    $ score conf list   
    dev *

The second command lists all configurations you have registered so far and will
mark the default configuration with an asterisk. Since you only have one
configuration, it is automatically your default configuration.

Your :mod:`score.cli` installation is now configured. Let's install another
handy module for development: :mod:`score.shell`.

.. code-block:: console

    $ pip install score.shell
    $ score shell

>>> score.moswblog.government_grant
0

The package :mod:`score.cli` just manages your configuration files and provides
the executable called *score*. The other module—:mod:`score.shell`— registered
a new :term:`shell command`, that you can access easily through the command
line. In this case, the shell command provides a python shell with your readily
configured SCORE application.

Let's now :ref:`create the moswblog CLI <tutorial_cli_command>` with our own
entry point.
