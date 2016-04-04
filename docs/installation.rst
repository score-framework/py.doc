.. _installation:

************
Installation
************

Quickstart
==========

- :ref:`Make sure you have python 3 installed <installation_python3>`

- :ref:`Open a new command shell <installation_open_shell>`

- :ref:`Install score's projects management tool into your home folder
  <installation_projects>`:
 
  .. code-block:: console

    sirlancelot@spamalot:~$ pip3 install --user score.projects
    Collecting score.projects
      ...
    Successfully installed click networkx score.cli score.init score.projects vex

- :ref:`Add the score executable to your $PATH <installation_postinstall>`:

  .. code-block:: console

    sirlancelot@spamalot:~$ python3 -c 'import score.cli; score.cli.setup()'

- :ref:`Close the old shell and open a new one to ensure you can call score
  <installation_postinstall>`:

  .. code-block:: console

    sirlancelot@spamalot:~$ score
    Usage: score [OPTIONS] COMMAND [ARGS]...
    
    Options:
      -c, --conf PATH  The configuration to use.
      --help           Show this message and exit.
    
    Commands:
      conf      Manages configurations.
      projects  Create or load your projects

- Head over to the :ref:`tutorial <tutorial>`, if you want to learn how
  to use score.


Step-By-Step
============

.. _installation_python3:

Install Python 3
----------------

There are currently two maintained branches of Python:

- The old python2, which is no longer developed, but still receives bug-fixes
  and security updates, and
- The new python3, which is the active branch where new features are added.

``score`` only works on newer python versions, so you might need to update your
system. You can open up a terminal and enter the following command to test if
you have the python 3::

  python3

If the above command fails with an error, you will need to `download and install
python3`_.

.. _download and install python3: https://www.python.org/downloads/


.. _installation_open_shell:

Opening a new command shell
---------------------------

A `command shell`_ allows the most basic form of interaction on a computer
system: by writing commands as text. It may feel awkward if you haven't used a
shell before, but has the benefit of working more or less the same way across
different systems.

Since the authors of the framework work on unixoid operating systems
(including GNU/Linux and Mac OS), our tutorials all use a common format
of its `command line prompt`_::

  sirlancelot@spamalot:~/score$ dosomething
  ╰────┬────╯│╰──┬───╯│╰──┬──╯│ ╰────┬────╯
       │     │   │    │   │   │      │
       │     │   │    │   │   │      └─> The command to execute
       │     │   │    │   │   │
       │     │   │    │   │   └─> Prompt/Input separator
       │     │   │    │   │
       │     │   │    │   └─> Current folder, ~ means HOME folder
       │     │   │    │
       │     │   │    └─> Login/Folder separator
       │     │   │
       │     │   └─> Name of the host
       │     │
       │     └─> User/Host separator
       │
       └─> Name of the current user

.. _command shell: https://en.wikipedia.org/wiki/Command-line_interface
.. _command line prompt: https://en.wikipedia.org/wiki/Command-line_interface#Command_prompt

.. note::
    On *Mac OS X*, the application that will give you a shell is terminal_. You
    can just start the application and start pasting the commands into the new
    shell window.

    .. _terminal: http://en.wikipedia.org/wiki/Terminal_%28OS_X%29


.. _installation_projects:

Installing ``score.projects``
-----------------------------

pip_ is a python package for installing other python packages. It is capable of
installing packages in your user folder, if you pass it the ``--user`` flag. We
will use it to install the score module, that we will be using to manage
different projects:

  .. code-block:: console

    sirlancelot@spamalot:~$ pip3 install --user score.projects
    Collecting score.projects
      ...
    Successfully installed click networkx score.cli score.init score.projects vex

.. _pip: https://pypi.python.org/pypi/pip


.. _installation_postinstall:

Calling score
-------------

.. note::
    Since we are mostly operating on UNIX-based systems, we currently have no
    way of thoroughly testing an installation on *Windows*. You will have to
    add the `path to the score executable`_ to your `PATH` manually.

    On the other hand, if you have a working solution, we would very much
    appreciate a `pull request`_.

    .. _path to the score executable: https://docs.python.org/3/install/index.html#alternate-installation-the-user-scheme
    .. _PATH: http://www.computerhope.com/issues/ch000549.htm
    .. _pull request: https://github.com/score-framework/py.cli/blob/524388b707ff5a09e1044b0a3330eae2b84037bf/score/cli/setup.py#L56


One of the packages that was installed in the previous step is
:mod:`score.cli`. This module allows you to control your applications from the
command line.

After the installation of that package, we will need to teach your system where
to find the command line application `score`. This is done by updating your
`$PATH`__ declaration. :mod:`score.cli` ships with an installation script, that
will attempt just that. It will update your ``.bashrc`` or ``.zshrc`` to
contain the correct delaration:

.. code-block:: console

    sirlancelot@spamalot:~$ python3 -c 'import score.cli; score.cli.setup()'

__ https://en.wikipedia.org/wiki/PATH_%28variable%29

Afterwards, you should check if it worked. Just open a new shell (this is
important, as the changes do not take effect in your old shell) and see if you
can access score. If everything worked, it should look like the following:

  .. code-block:: console

    sirlancelot@spamalot:~$ score
    Usage: score [OPTIONS] COMMAND [ARGS]...
    
    Options:
      -c, --conf PATH  The configuration to use.
      --help           Show this message and exit.
    
    Commands:
      conf      Manages configurations.
      projects  Create or load your projects

If you get a "command not found" error instead, it means that the automatic
configuration failed and you will have to update your ``$PATH`` manually. It
must include the `folder where score was installed`_. The author of the lovely
`vex` python package has assembled a great explanation on this topic:

https://github.com/sashahart/vex#first-time-setup-for-python-beginners

.. _folder where score was installed: https://docs.python.org/3/install/index.html#alternate-installation-the-user-scheme


Tutorial
--------

Congratulations! You should head over to the :ref:`tutorial <tutorial>`
to learn how to put your newly installed framework to good use.
