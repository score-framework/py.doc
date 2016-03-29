.. _tutorial_project:

The Project
===========

Our customer, The Ministry of Silly Walks, wants to maintain a blogging portal,
where various members, and in some cases external authors, like The Spanish
Inquisition [1]_, are to publish news. Users can access the published blogs and
comment on individual postings.

Setup
=====

So let's start by creating the project using the projects module. We do this on
the command line, just like during the :ref:`installation`. We'll call our
module *moswblog*, as acronym of Ministry-of-Silly-Walks-Blog:

.. code-block:: console

      sirlancelot@spamalot:~$ score projects create moswblog
        ...
      (moswblog)sirlancelot@spamalot:~/moswblog$ score serve

The newly creted, completely empty application is now accessible as
http://localhost:6543. You will need to leave this console for the server to
continue working.

Let's start writing our :ref:`database layer <tutorial_db>`.


.. [1] You weren't expecting The Spanish Inquisition, were you?

