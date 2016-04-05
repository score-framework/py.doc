.. _tutorial_setup:

Setup
=====

We'll start by creating the project using the projects module. We do this on
the command line, just like during the :ref:`installation`. Let's call our
project *moswblog*, as acronym for Ministry-of-Silly-Walks-Blog. The python
package should be called *blog*, though:

.. code-block:: console

      sirlancelot@spamalot:~$ score projects create moswblog --package blog
        ...
      (moswblog)sirlancelot@spamalot:~$ 

That's it, we have created a new and completely empty python package. It even
contains an empty SCORE configuration file (*local.conf*), that we will expand
during the course of this tutorial.

Now, whenever you want to work on this project in a new shell, you can just
punch in the following to change into your project folder and activate its
:mod:`virtual python environment <python:venv>`:

.. code-block:: console

      sirlancelot@spamalot:~$ score projects load moswblog
      (moswblog)sirlancelot@spamalot:~$ 

It is time to define our :ref:`database layer <tutorial_db>`.
