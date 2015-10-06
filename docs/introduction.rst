************
Introduction
************

Why did we actually come up with the idea of writing a new framework, when
there are so many, so well-executed python frameworks out there? This question
actually has two answers:

- It is tradition. We at strg.at_ always had a framework that was
  custom-tailored for our very own needs. And now that we have come to
  python-land, we felt the need to build a home here, since we're planning on
  staying here for quite some time.

- The more technical answer is: Easier development. Since we have a very
  narrow audience—ourselves and our customers—we can focus on extremely
  specific features that we need regularly during our development cycles. For
  example, we have the freedom—and the need—to change our database classes
  during development often; to support every need our customers develop during
  the creation of their next favorite software. That's why we have a database
  module that has the built-in feature to delete and re-create the database, as
  well as a data loader that can quickly insert test data to immediatly
  continue development after such a reset.

.. _strg.at: http://strg.at

.. _score_constraints:

Technical Constraints
=====================

The projects presented on the :ref:`front page <score_index>` impose some
technical constraints on our products:

- First and foremost: all projects have **much more reads than writes** —
  there is a limited editorial staff creating content for a *huge* audience.
  Our database receives approximately three orders of magnitude more reads
  than writes.

- Many projects have very **high traffic** volumes. Even more than any dynamic
  web application could ever handle. We have to rely on heavy caching on
  various occasions.

- Another must-have is **high availability**. When a project has lots of
  expenses (editorial staff, hardware, etc.), it needs to generate enough
  income to compensate for them. Since websites generate income per time, any
  outage leads to huge opportunity costs (lost advertising revenue) and/or
  even more direct costs (idle editorial staff that cannot access the
  backend).
  
.. _score_vs_pyramid:

score vs pyramid
================

We built ``score`` on top of another beautiful web framework: pyramid_. As our
:ref:`philosophy <devguide_philosophy>` is to always respect an existing
eco-system, we tried to change the normal pyramid workflow as little as
possible.

But if you are new to pyramid, as well as score, all the better: you now have
the chance to learn two beautiful libraries at once. The only confusing part
will be to understand what feature is part of which framework.

We would recommend working through the :ref:`blog tutorial <blog_tutorial>` in
any case, whether you already know pyramid or not. There you will encounter
calls to various functions. By keeping a close eye on the origin of those
functions, you should get a good understanding of which features come from
which library.

.. _pyramid: http://docs.pylonsproject.org/projects/pyramid/en/latest/
