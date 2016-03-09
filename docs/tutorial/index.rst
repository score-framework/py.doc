.. _tutorial:

*************
Blog Tutorial
*************

Introduction
============

Aim of this tutorial is to provide a gentle introduction to various aspects of
The SCORE Framework. We will create a small but complete blogging portal with
a proper database layer and maintainable frontend code.

The Project
===========

Our customer, The Ministry of Silly Walks, wants to maintain a blogging portal,
where various members, and in some cases external authors, like The Spanish
Inquisition [1]_, are to publish news. Users can access the published blogs and
comment on individual postings.

Specification
=============

There are four types of Users to the system:

- **Administrators**, which have unrestricted access to all resources and
  features. They are the only ones that can create new Blogs and Bloggers.

- **Internal Bloggers**, that are allowed to:

  - write and publish articles on their own blogs only and
  - edit and publish articles by other bloggers.

- **External Bloggers**, who can write blog entries, but are not allowed to
  publish them.

- **Frontend Users**, that can write comments to published blogs.

All **Backend Users** (Administrators, Internal Bloggers and External
Bloggers) can further do anything a Frontend User can.

A **Blog** is a sub-portal that is managed by a single Internal Blogger. Apart
from a unique name, it is actually just a container for Articles.

An **Article** is a document created by a Blogger and has the following
content-related attributes:

- title
- url
- teaser text
- body
- date & time it was last updated
- tags

The body text and the teaser text are to be written in reStructuredText, the
favorite markup language of The Ministry of Silly Walks (who knew!?)

The **frontend** consists of just five views, four of which are a listing of
Articles:

- start page (lists newest articles)
- blog page (lists articles of a Blog)
- blogger page (lists articles of a certain Blogger)
- tag page (lists articles with given tag)
- article page

