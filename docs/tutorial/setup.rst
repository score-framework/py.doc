.. _tutorial_setup:

Preparation
===========

We'll start by creating the project using the projects module. We do this on
the command line, just like during the :ref:`installation`. Let's call our
project *moswblog*, as acronym for Ministry-of-Silly-Walks-Blog. The python
package should be called *blog*, though:

.. code-block:: console

      sirlancelot@spamalot:~$ score projects create moswblog --package blog
        ...
      (moswblog)sirlancelot@spamalot:~$ 

.. note::

    Did you notice the new prefix to your shell prompt? It now reads
    ``(moswblog)sir…``. This means that you are inside the :mod:`virtual python
    environment <python:venv>` environment of your project. The ``projects``
    module has automatically entered the virtual environment after creating it.
    
    You can leave this virtual environment by exiting your current
    shell—usually either by pressing ``<CTRL-D>`` or typing ``exit``.

That's it, we have created a new and completely empty python package. It even
contains an empty SCORE configuration file (*local.conf*), which we will expand
during the course of this tutorial.

.. note::

    You current shell is inside your project's virtual environment, so you can
    just work inside this shell. If you want to open a *new* shell, though, you
    will need to enter the project's virtual environment again. This is done by
    issueing the following command in your new shell:
    
    .. code-block:: console

          sirlancelot@spamalot:~$ score projects load moswblog
          (moswblog)sirlancelot@spamalot:~$ 

It is time to define our :ref:`database layer <tutorial_db>`.
