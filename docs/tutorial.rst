.. _blog_tutorial:

*************
Blog Tutorial
*************

Introduction
============

Aim of this tutorial is to provide a gentle introduction to various aspects of
the score framework. We will create a small but complete blogging portal with
a proper database layer, sane CSS and modular javascript. Our main priorities
will be a correct and — even more importantly — a maintainable implementation.

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
- **Frontend Users** that can write comments to published blogs.

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

.. _blog_tutorial_setup:

Setup
=====

.. note::
    Since the authors of the framework work on unixoid operating systems
    (including GNU/Linux and Mac OS), our tutorials all use a common format
    of its `command line prompt`_::

      (moswblog)sirlancelot@spamalot:~/projects/blog$ dosomething
      ╰────┬───╯╰────┬────╯│╰──┬───╯│╰──────┬──────╯│ ╰────┬────╯
           │         │     │   │    │       │       │      │
           │         │     │   │    │       │       │      └─> The command to execute
           │         │     │   │    │       │       │
           │         │     │   │    │       │       └─> Prompt/Input separator
           │         │     │   │    │       │
           │         │     │   │    │       └─> Current folder, ~ means HOME folder
           │         │     │   │    │
           │         │     │   │    └─> Login/Folder separator
           │         │     │   │
           │         │     │   └─> Name of the host
           │         │     │
           │         │     └─> User/Host separator
           │         │
           │         └─> Name of the current user
           │
           └─> Name of the current virtual environment (if there is one)

    .. _command line prompt: https://en.wikipedia.org/wiki/Command-line_interface#Command_prompt

.. note::
    On *Mac OS X*, the application that will give you a shell is terminal_. You
    can just start the application and start pasting the commands into the new
    shell window.

    .. _terminal: http://en.wikipedia.org/wiki/Terminal_%28OS_X%29

Let's first create our environment as described in the :ref:`installation
documentation <score_install>`:

.. code-block:: console

  sirlancelot@spamalot:~$ mkvirtualenv --python=$(which python3) moswblog
    ...
  (moswblog)sirlancelot@spamalot:~$ pip install score.pyramid
    ...
  (moswblog)sirlancelot@spamalot:~$ pcreate -t score moswblog
    ...
  (moswblog)sirlancelot@spamalot:~$ cd moswblog
  (moswblog)sirlancelot@spamalot:~/moswblog$ python setup.py develop
    ...
  (moswblog)sirlancelot@spamalot:~/moswblog$ pserve --reload development.ini
    ...

We can now open our browser and make sure that everything in the *general* and
*development* sections are working: http://localhost:6543.

You will need to leave this console open and continue working through a new
one. So open a new console and issue the following commands:

.. code-block:: console

    sirlancelot@spamalot:~$ cd moswblog
    sirlancelot@spamalot:~/moswblog$ workon moswblog
    (moswblog)sirlancelot@spamalot:~/moswblog$ 

.. note::

    If at any time, during the tutorial, your browser complains that the web
    server is not responding, you might need to come back to your initial
    console to check if the ``pserve`` command is still running. If it is not,
    you can just restart it with the same command:

    .. code-block:: console

        (moswblog)sirlancelot@spamalot:~/moswblog$ pserve --reload development.ini
          ...

We will also need to install some additional packages for this tutorial. Let's
get that out of our way:

.. code-block:: console

  (moswblog)sirlancelot@spamalot:~/moswblog$ pip install sqlalchemy_utils passlib docutils PyYAML
    ...

.. note::

    It is possible that the installation of PyYAML outputs an error during
    installation. In most cases, this is just a failed attempt to compile the
    optional C module. If the ``pip`` command itself does not terminate with an
    error, the installation should be fine.

We should also update the installation file of our module, otherwise we will
have trouble deploying our application onto the live server farm cloud thingie.
Edit ``setup.py`` and add the freshly installed packages to the list of
``install_requires``:

.. code-block:: python

    setup(
        # ...
        install_requires=[
            # ...
            'sqlalchemy_utils',
            'passlib',
            'docutils',
            'PyYAML',
        ],
        # ...

Database Basics
===============

.. note::

    We will be editing various files from now on, most of which reside in a
    folder called ``moswblog``, which might lead to some confusion: We have
    already created a *project folder* called ``moswblog`` in our home
    directory during the setup step, above. Therein lies another folder with
    the same name, which is a *python package folder*.

    We are assuming that you have changed into your *project folder* (i.e.
    ~/moswblog) and provide the file names relative to this directory. This
    means that the absolute path of the file ``moswblog/db/user.py`` is
    actually ``~/moswblog/moswblog/db/user.py``, since it resides in the python
    package we have created for our project (using ``pcreate``, above).

User
----

First, we need to create our database objects. For this, we will create a few
files. Let's start with the users in ``moswblog/db/user.py``:

.. code-block:: python
    :linenos:
    :emphasize-lines: 1,8

    from .base import Storable
    from sqlalchemy import (
        Column,
        String,
    )
    from sqlalchemy_utils.types.password import PasswordType

    class User(Storable):
        username = Column(String, nullable=False)
        password = Column(PasswordType(schemes=['pbkdf2_sha512']))
        name = Column(String, nullable=False)

    class Administrator(User):
        pass

    class Blogger(User):
        pass

    class InternalBlogger(Blogger):
        pass

    class ExternalBlogger(Blogger):
        pass

    class FrontendUser(User):
        pass

We can import our readily-configured Storable :ref:`base class <db_base>`
(line #1) and use it to create a class tree for the users of our system. As
the name suggests, the Base class needs to be the parent class of all classes
that should be persisted into the database (line #8).

Content
-------

The next file is the one containing the blogs and articles called
``moswblog/db/content.py``:

.. code-block:: python
    :linenos:
    :emphasize-lines: 15,16

    from .base import Storable
    from score.db import IdType
    from sqlalchemy import (
        Column,
        String,
        Boolean,
        DateTime,
        ForeignKey,
    )
    from sqlalchemy.orm import relationship


    class Blog(Storable):
        name = Column(String, nullable=False)
        owner_id = Column(IdType, ForeignKey('_internal_blogger.id'), nullable=False)
        owner = relationship('InternalBlogger', backref='blogs')

    class Article(Storable):
        author_id = Column(IdType, ForeignKey('_blogger.id'), nullable=False)
        author = relationship('Blogger', backref='articles')
        blog_id = Column(IdType, ForeignKey('_blog.id'), nullable=False)
        blog = relationship('Blog', backref='articles')
        title = Column(String(200), nullable=False)
        url = Column(String(200), nullable=False)
        teaser = Column(String, nullable=False)
        body = Column(String, nullable=False)
        datetime = Column(DateTime, nullable=False)
        published = Column(Boolean, nullable=False)

    class ArticleTag(Storable):
        article_id = Column(IdType, ForeignKey('_article.id'), nullable=False)
        article = relationship(Article, backref='tags')
        name = Column(String(30))

This time, we are using a nice feature of sqlalchemy: relationships. Every
blog has an owner, which has to be an InternalBlogger. So we have to create a
column referencing the other table. We will call this column ``owner_id``, so
we can later create a member ``owner``, which contains the actual object.

The ``owner_id`` consists of a single id field [2]_, which we configure with a
`foreign key`_ reference to the table containing our Internal Bloggers. The
name of a table is always determined as described in the documentation of
:func:`.cls2tbl`.

The ``owner`` member is what adds the magic: It will automatically provide the
correct InternalBlogger object with the id found in the ``owner_id``. This is
a simple :ref:`relationship <sqlalchemy:relationship_patterns>` as defined by
sqlalchemy. One interesting bit is the ``backref`` argument: it adds a new
member with that name to the referenced class. We will later use that member
to access an Internal Bloggers blogs.

Including the Classes
---------------------

Now that we have created some new classes, we need to include them in our
database package. Let's open up the file ``moswblog/db/__init__.py`` and add the
new classes:

.. code-block:: python
    :linenos:

    from .base import *
    from .user import *
    from .content import *

Initializing the Database
-------------------------

The default configuration will write to a sqlite_ file, which is a database
engine which can store its entire database in a single file. You can change
the database in the configuration file ``development.ini``.

Now that we have defined all our classes, we need to create the database
tables, views, foreign keys, triggers, etc. We will use the command-line
application ``score`` for this purpose:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ score db reset development.ini
      ...

This should generate a lot of output, while all required database entities are
created. You can connect to the database and inspect it, if you want:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ sqlite3 database.sqlite3

.. code-block:: sqlite3

    SQLite version 3.8.7.4 2014-12-09 01:34:36
    Enter ".help" for usage hints.
    sqlite> .tables
    _administrator     _external_blogger  article            frontend_user    
    _article           _frontend_user     article_tag        internal_blogger 
    _article_tag       _internal_blogger  blog               user             
    _blog              _user              blogger          
    _blogger           administrator      external_blogger 
    sqlite> .schema _blogger
    CREATE TABLE _blogger (
        id INTEGER NOT NULL, 
        PRIMARY KEY (id), 
        FOREIGN KEY(id) REFERENCES _user (id)
    );
    CREATE TRIGGER autodel_blogger AFTER DELETE ON _blogger
    FOR EACH ROW BEGIN
      DELETE FROM _user WHERE id = OLD.id;
    END;
    sqlite> .quit

We have a table, as well as a view_ for each class we created earlier. You can
read up on the rationale behind this in the documentation of the
:mod:`score.db` module's :ref:`internals <db_view>`.

.. _sqlite: https://sqlite.org/about.html
.. _foreign key: https://en.wikipedia.org/wiki/Foreign_key
.. _view: https://en.wikipedia.org/wiki/View_%28SQL%29


Our First URL
=============

The Entrypoint
--------------

We had defined four frontend views in our specification, so we will start by
replacing the configuration-tests with some more interesting features one by
one. Let's first create the home page entry point in
``moswblog/page/start.py``:

.. code-block:: python
    :linenos:

    import moswblog.db as db
    from pyramid.renderers import render
    from pyramid.view import view_config

    @view_config(route_name='start', renderer='start.jinja2')
    def start(request):
        articles = request.db.query(db.Article).\
                filter(db.Article.published == True).\
                order_by(db.Article.datetime.desc()).\
                limit(10)
        return {'articles': articles}

Whoa, there is a lot going on in these few lines. Let's go over them step by
step:

- Lines ``#5`` and ``#6``: We define a so-called :term:`view <pyramid:view>`
  as a function. We are giving it the name "start" in line #5 and the function
  we define below will accept a :term:`request <pyramid:request>` object.

- Also in line ``#5``, we instruct :ref:`pyramid's rendering system
  <pyramid:renderers_chapter>` to render a template called ``start.jinja2``
  at the end of this function with the parameters returned by the function. The
  result of the rendering process — i.e. the rendered template, a string
  containing HTML in this case — is return as the response body to the client.

- Lines ``#7`` through ``#10``: We are using the database
  :term:`session <sqlalchemy:session>` that was automatically added to the
  request by our :mod:`db <score.db>` module to retrieve a list of the newest
  published Articles.

- Line ``#11``: The dictionary returned by this function contains the
  parameters to the template we defined earlier, in line ``#5``.


The Template
------------

Our next step is to create the template called ``start.jinja2`` we were
referencing in our entry point. Let's open the file
``moswblog/tpl/start.jinja2`` and write the following:

.. code-block:: jinja
    :linenos:

    {% extends "_page.jinja2" %}
    {% block content %}
        <h1>Ministry of Silly Walks</h1>
        <p>Newest articles:</p>
        <ul>
            {% for article in articles: %}
                <li class="article">
                    <p class="article-title">{{ article.title }}</p>
                    <p class="article-teaser">{{ article.teaser }}</p>
                </li>
            {% endfor %}
        </ul>
    {% endblock %}

The URL
-------

The only thing left to do is to attach our entry point to a URL. The place to
establish the URL is ``moswblog/__init__.py``. We will move the configuration
checklist to a different URL (line #4) and register our own route (line #3):

.. code-block:: python
    :linenos:
    :emphasize-lines: 3,4

    def init(file):
        # ...
        config.add_route('start', '/')
        config.add_route('dev/checklist', '/_dev/checklist')
        config.add_route('dev/checklist/ajax', '/_dev/checklist/{command}')
        # ...

You can read up on the configuration of URLs in :ref:`pyramid's documentation
on URL dispatch <pyramid:urldispatch_chapter>`.

Alright, we are now ready to call our brand new page! Visit
http://localhost:6543 ...

... to find out that we have absolutely no Articles in our database! At least
we have created a working page.

Creating Dummy Data
===================

Luckily we can add some test data quite quickly. Open
``moswblog/scripts/db.py`` and add the following lines to the ``_gendummy``
function:

.. code-block:: python

    # ...
    from score.db import load_data
    # ...

    def _gendummy(session):
        objects = load_data('http://score-framework.org/doc/_downloads/moswblog.yaml')
        for cls in objects:
            for id in objects[cls]:
                session.add(objects[cls][id])

We can now add some test data through the command line interface:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ score db gendummy development.ini

Let's see how our page looks with the data: http://localhost:6543 ... Alright!
Time to move to the next steps.

Article View
============

We'll create the page displaying a single article and modify our previous page
to link to each article.

The New URL
-----------

Create the file  ``moswblog/page/article.py`` and insert the following:

.. code-block:: python
    :linenos:

    import moswblog.db as db
    from pyramid.renderers import render
    from pyramid.view import view_config

    @view_config(route_name='article', renderer='article.jinja2')
    def article(request):
        article = request.db.query(db.Article).\
            filter(db.Article.id == int(request.matchdict['id'])).\
            first()
        return {'article': article}

This takes care of the controller; on to the view in
``moswblog/tpl/article.jinja2``:

.. code-block:: jinja
    :linenos:

    {% extends "_page.jinja2" %}
    {% block content %}
        <h1>{{ article.title }}</h1>
        <p>{{ article.teaser }}</p>
        {{ article.body }}
    {% endblock %}

And now, give the view a URL in ``moswblog/__init__.py``:

.. code-block:: python

    def init(file):
        # ...
        config.add_route('start', '/')
        config.add_route('article', '/article/{id}')
        config.add_route('dev/checklist', '/_dev/checklist')
        config.add_route('dev/checklist/ajax', '/_dev/checklist/{command}')
        # ...

Linkage
-------

Now that we have URLs for our Articles, we should update the start page to
show these links. Let's revisit ``moswblog/tpl/start.jinja2`` and change this
line …

.. code-block:: jinja
    :linenos:
    :lineno-start: 8

    <p class="article-title">{{ article.title }}</p>

… into this:

.. code-block:: jinja
    :linenos:
    :lineno-start: 8

    <a href="{{ request.route_url('article', id=article.id) }}"
        class="article-title">{{ article.title }}</a>

Not bad! The body text looks messed up, though. This is because we haven't
converted the reStructuredText into HTML yet. Let's do just that next!

Formatting reStructuredText
===========================

The :mod:`tpl <score.tpl>` module has a handy feature we will use next:
:ref:`filters <tpl_filters>`! Since we already installed docutils
:ref:`earlier <blog_tutorial_setup>`, we can immediately create the file
``moswblog/tpl/__init__.py`` and define the filter function:

.. code-block:: python
    :linenos:

    from docutils.core import publish_parts

    def rst2html(rst):
        return publish_parts(rst, writer_name='html')['body']

We will need to update our ``moswblog/__init__.py`` file and register our
filter function after score initialization:

.. code-block:: python

    ...
    from .tpl import rst2html
    ...

    def init(file):
        ...
        config, scoreconf = scoreinit(file)
        scoreconf['score.tpl'].renderer.add_filter('html', 'rst', rst2html, escape_output=False)
        ...

We have just created a filter function called *rst* which is available in
*html* documents. The only thing left to do is to put that filter to use in 
``moswblog/tpl/article.jinja2``:

.. code-block:: jinja
    :linenos:
    :emphasize-lines: 5

    {% extends "_page.jinja2" %}
    {% block content %}
        <h1>{{ article.title }}</h1>
        <p>{{ article.teaser }}</p>
        {{ article.body | rst }}
    {% endblock %}

The article view should now show a well-formatted body.

Remaining frontend URLs
=======================

Three frontend views remain, all of which are actually a listing of Articles.
Since these views are so similar, we will create just one template to render
them all. Create the folder ``moswblog/tpl/articles`` and edit the file
``moswblog/tpl/articles/list.jinja2``:

.. code-block:: jinja
    :linenos:

    {% extends "_page.jinja2" %}
    {% block content %}
        <h1>{% block heading %}Ministry of Silly Walks{% endblock %}</h1>
        <p>{% block lead %}{% endblock %}</p>
        <ul>
            {% for article in articles: %}
                <li class="article">
                    <a href="{{ request.route_url('article', id=article.id) }}"
                       class="article-title">{{ article.title }}</a>
                    (in blog 
                    <a href="{{ request.route_url('articles/by_blog', id=article.blog_id) }}"
                       class="article-blog">{{ article.blog.name }}</a>)
                    <p class="article-teaser">{{ article.teaser }}</p>
                </li>
            {% endfor %}
        </ul>
    {% endblock %}

This file will serve as base template for jinja's powerful :ref:`inheritance
<jinja:template-inheritance>` feature. In fact, we have already used this
feature several times already: Each template (even this one) had a line
telling jinja that the template was extending another template called
``_page.jinja2``. When the extending template is rendered, it will instead
render the template it is extending, but replace certain blocks with those
provided in the current file.

Now let's update the first listing template, ``moswblog/tpl/start.jinja2``,
and replace the whole with just these lines:

.. code-block:: jinja
    :linenos:

    {% extends "articles/list.jinja2" %}
    {% block lead %}Newest articles{% endblock %}

We have just shortened the template tremendously. If creating article listings
has become this easy, why don't we add the remaining template files right now?

- ``moswblog/tpl/articles/by_blog.jinja2``

    .. code-block:: jinja
        :linenos:

        {% extends "articles/list.jinja2" %}
        {% block lead %}Articles in blog <em>{{ blog.name }}</em>{% endblock %}

- ``moswblog/tpl/articles/by_blogger.jinja2``

    .. code-block:: jinja
        :linenos:

        {% extends "articles/list.jinja2" %}
        {% block lead %}Articles by <em>{{ blogger.name }}</em>{% endblock %}

- ``moswblog/tpl/articles/by_tag.jinja2``

    .. code-block:: jinja
        :linenos:

        {% extends "articles/list.jinja2" %}
        {% block lead %}Articles tagged <em>{{ tag }}</em>{% endblock %}

Alright, now let's use these templates in some pyramid views in
``moswblog/page/article.py``, ...

.. code-block:: python
    :linenos:
    :lineno-start: 12

    @view_config(route_name='articles/by_blog', renderer='articles/by_blog.jinja2')
    def articles_by_blog(request):
        blog = request.db.query(db.Blog).\
                filter(db.Blog.id == int(request.matchdict['id'])).\
                first()
        return {'blog': blog, 'articles': blog.articles}

    @view_config(route_name='articles/by_blogger', renderer='articles/by_blogger.jinja2')
    def articles_by_blogger(request):
        blogger = request.db.query(db.Blogger).\
                filter(db.Blogger.id == int(request.matchdict['id'])).\
                first()
        return {'blogger': blogger, 'articles': blogger.articles}

    @view_config(route_name='articles/by_tag', renderer='articles/by_tag.jinja2')
    def articles_by_tag(request):
        tag = request.matchdict['tag']
        articles = request.db.query(db.Article).\
                filter(db.Article.tags.any(db.ArticleTag.name == tag)).\
                all()
        return {'tag': tag, 'articles': articles}

… update the links in our main article template
``moswblog/tpl/article.jinja2`` …

.. code-block:: jinja
    :linenos:

    {% extends "_page.jinja2" %}
    {% block content %}
        <h1>{{ article.title }}</h1>
        <p>{{ article.teaser }}
            (by <a href={{ request.route_url('articles/by_blogger', id=article.author_id) }}
                    class="article-author">{{ article.author.name }}</a>)
        </p>
        <p class="article-tags">
            {% for tag in article.tags %}
                <a href={{ request.route_url('articles/by_tag', tag=tag.name) }}>
                    {{ tag.name }}</a>
            {% endfor %}
        </p>
        {{ article.body | rst }}
    {% endblock %}

… and attach these views to URLs in ``moswblog/__init__.py``:

.. code-block:: python
    :linenos:

    def init(file):
        # ...
        config.add_route('start', '/')
        config.add_route('article', '/article/{id}')
        config.add_route('articles/by_blog', '/blog/{id}')
        config.add_route('articles/by_blogger', '/author/{id}')
        config.add_route('articles/by_tag', '/tag/{tag}')
        # ...

The only thing missing in our frontend views is now the commenting feature and
taste. But since we're not done with our features — commenting is still missing
— we will put off the design for some more time.

Adding Context
==============

You might have noticed that we are currently serving some invalid URLs with an
error code. For example http://localhost:6543/article/141254. We will fix just
that and add some :term:`context <pyramid:context>` to our views, which we
will need for authorization lateron. Let's start by rewriting our views to
require and use a context object. Edit ``moswblog/page/article.py`` and
replace the view callables with the following:

.. code-block:: python
    :linenos:
    :emphasize-lines: 2,4,7,9,13,15,19,21,23

    @view_config(route_name='article', renderer='article.jinja2',
                 context=db.Article)
    def article(request):
        return {'article': request.context}

    @view_config(route_name='articles/by_blog', renderer='articles/by_blog.jinja2',
                 context=db.Blog)
    def articles_by_blog(request):
        blog = request.context
        return {'blog': blog, 'articles': blog.articles}

    @view_config(route_name='articles/by_blogger', renderer='articles/by_blogger.jinja2',
                 context=db.Blogger)
    def articles_by_blogger(request):
        blogger = request.context
        return {'blogger': blogger, 'articles': blogger.articles}

    @view_config(route_name='articles/by_tag', renderer='articles/by_tag.jinja2',
                 context=db.ArticleTag)
    def articles_by_tag(request):
        tag = request.context
        articles = request.db.query(db.Article).\
                filter(db.Article.tags.contains(tag)).\
                all()
        return {'tag': tag, 'articles': articles}

We have defined a context class for each view. It is no longer enough for a
URL to match, the URL must also denote a valid object of a certain type. We
need to update our routing definitions to provide said objects. Let's change
our routes in ``moswblog/__init__.py``:

.. code-block:: python

    # ...
    from score.db.pyramid import (
        create_context_factory as mkfactory,
        create_default_pregenerator as mkpregen
    )
    # ...

    def init(file):
        # ...
        config.add_route('article', '/article/{id}',
                         factory=mkfactory(db.Article),
                         pregenerator=mkpregen(db.Article))
        config.add_route('articles/by_blog', '/blog/{id}',
                         factory=mkfactory(db.Blog),
                         pregenerator=mkpregen(db.Blog))
        config.add_route('articles/by_blogger', '/author/{id}',
                         factory=mkfactory(db.Blogger),
                         pregenerator=mkpregen(db.Blogger))
        config.add_route('articles/by_tag', '/tag/{tag}',
                         factory=mkfactory(db.ArticleTag, 'name', 'tag'),
                         pregenerator=mkpregen(db.ArticleTag, 'name', 'tag'))
        # ...

Our routes now have a :func:`factory
<score.db.pyramid.create_context_factory>`, as well as a :func:`pregenerator
<score.db.pyramid.create_default_pregenerator>`.  This basically means that it
is now sufficient to have an article object to generate the URL. One no longer
needs to know which members need to be passed to the :attr:`route_url
<pyramid:pyramid.request.Request.route_url>` function. We now have the
flexibility to change the URL to anything we want at a later point — for
example to the article slug instead of the id!

Since our routes have changed, we need to adjust all calls to route_url. There
are two occurences in ``moswblog/tpl/articles/list.jinja2`` …

.. code-block:: jinja
    :linenos:
    :emphasize-lines: 1,4
    :lineno-start: 8

    <a href="{{ request.route_url('article', article) }}"
        class="article-title">{{ article.title }}</a>
    (in blog 
    <a href="{{ request.route_url('articles/by_blog', id=article.blog_id) }}"
       class="article-blog">{{ article.blog.name }}</a>)

… and two more in ``moswblog/tpl/article.jinja2``:

.. code-block:: jinja
    :linenos:
    :emphasize-lines: 2,7
    :lineno-start: 4

    <p>{{ article.teaser }}
        (by <a href={{ request.route_url('articles/by_blogger', article.author) }}
                class="article-author">{{ article.author.name }}</a>)
    </p>
    <p class="article-tags">
        {% for tag in article.tags %}
            <a href={{ request.route_url('articles/by_tag', tag) }}>
                {{ tag.name }}</a>
        {% endfor %}
    </p>

You can have a look at the documentation of :meth:`add_route
<pyramid:pyramid.config.Configurator.add_route>` for the details of these
calls or :ref:`pyramid's documentation on URL dispatch
<pyramid:urldispatch_chapter>` for an in-depth explanation of the routing
process.

Commenting
==========

We'll start by expanding our database. Open up ``moswblog/db/content.py`` and
add these lines:

.. code-block:: python
    :linenos:
    :lineno-start: 35

    class Comment(Storable):
        author_id = Column(IdType, ForeignKey('_user.id'), nullable=False)
        author = relationship('User', backref='comments')
        article_id = Column(IdType, ForeignKey('_article.id'), nullable=False)
        article = relationship(Article, backref='comments')
        datetime = Column(DateTime, nullable=False)
        text = Column(String, nullable=False)

We have just created a new Storable class. This means that we should instruct
our database to create the table for this class:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ score db update development.ini

Let's continue to the template for articles, ``moswblog/tpl/article.jinja2``
and add these lines at the end of the content block:

.. code-block:: jinja
    :linenos:
    :lineno-start: 15

    <ul class="article-comments">
        {% for comment in article.comments %}
            <div class="article-comment-author">
                {{ comment.author.name }}
            </div>
            <div class="article-comment-text">
                {{ comment.text }}
            </div>
        {% endfor %}
    </ul>
    {% if request.user %}
        <form method="POST">
            <textarea name="text"></textarea>
            <input type="submit" />
        </form>
    {% endif %}

Before we can finish implementing the commenting, we will need to finalize the
login.

Authentication & Authorization
==============================

Since only logged in users are allowed to post comments, we will need a
login process. For the sake of simplicity, we will omit the registration form
and instead use the automatically inserted users in our test data. 

Let's update ``moswblog/__init__.py`` to allow logging in from anywhere:

.. code-block:: python

    # ...
    from pyramid.authentication import AuthTktAuthenticationPolicy
    from pyramid.authorization import ACLAuthorizationPolicy
    from score.db.pyramid import AutologinAuthenticationPolicy
    # ...

    def init(file):
        # ...
        authbase = AuthTktAuthenticationPolicy('insertthefunniestjokeintheworldhere',
                callback=lambda user_id, request: request.user.aclgroups, hashalg='sha512')
        auth = AutologinAuthenticationPolicy(authbase, db.User)
        config.add_request_method(auth.user, 'user', property=True)
        config.set_authentication_policy(auth)
        config.set_authorization_policy(ACLAuthorizationPolicy())
        # ...

We can now expand our base template, ``moswblog/tpl/_page.jinja2``, to provide
a login form if the user is not logged in:

.. code-block:: jinja
    :linenos:
    :lineno-start: 8

    <div id="header">
        {% if request.user %}
            Hello, <span class="user">{{ request.user.name }}</span>
            <a href="{{ request.route_url('logout') }}">logout</a>
        {% else %}
            <form method="post">
                <input type="hidden" value="{{ request.url }}" />
                <ul>
                    <li>Username: <input name="username" /></li>
                    <li>Password: <input type="password" name="password" /></li>
                    <li><input type="submit" /></li>
                </ul>
            </form>
        {% endif %}
    </div>
    <div id="page">
        {% block content %}{% endblock %}
    </div>

We just need one more route for logging out, and the login process is complete.
Create ``moswblog/page/login.py`` and insert the following, …

.. code-block:: python
    :linenos:

    from pyramid.httpexceptions import HTTPFound
    from pyramid.security import forget
    from pyramid.view import view_config

    @view_config(route_name='logout')
    def logout(request):
        headers = forget(request)
        return HTTPFound(request.referrer, headers=headers)

… and add the URL to this view in ``moswblog/__init__.py``:

.. code-block:: python

    # ...
    def init(file):
        # ...
        config.add_route('logout', '/logout')

And now, the time has come to exploit the contexting feature we implemented
earlier. We will add a list of groups to each user type in
``moswblog/db/user.py``, …

.. code-block:: python
    :linenos:
    :lineno-start: 8

    class User(Storable):
        username = Column(String, nullable=False)
        password = Column(PasswordType(schemes=['pbkdf2_sha512']))
        name = Column(String, nullable=False)
        aclgroups = tuple()

    class Administrator(User):
        aclgroups = ('logged-in', 'blogger', 'internal-blogger', 'external-blogger', 'admin')

    class Blogger(User):
        aclgroups = ('logged-in', 'blogger')

    class InternalBlogger(Blogger):
        aclgroups = ('logged-in', 'blogger', 'internal-blogger')

    class ExternalBlogger(Blogger):
        aclgroups = ('logged-in', 'blogger', 'external-blogger')

    class FrontendUser(User):
        aclgroups = ('logged-in')

… define the permissions required to create a comment in
``moswblog/db/content.py``, …

.. code-block:: python
    :linenos:

    from pyramid.security import Allow, Everyone
    # ...

    class Article(Storable):
        __acl__ = [ (Allow, 'blogger', 'edit'),
                    (Allow, 'logged-in', 'comment')]
        # ...

… and we are then able to define a very specific view configuration that will
handle new comments. Add these lines in front of the existing *view_config*
for the same *route_name* in ``moswblog/page/article.py``:

.. code-block:: python
    :linenos:
    :lineno-start: 3

    # ...
    from datetime import datetime

    @view_config(route_name='article', renderer='article.jinja2',
                 context=db.Article, request_method='POST',
                 permission='comment', effective_principals=('logged-in',))
    def article_comment(request):
        if 'text' in request.POST:
            comment = db.Comment(
                author=request.user,
                article=request.context,
                datetime=datetime.now(),
                text=request.POST['text']
            )
            request.db.add(comment)
        return {'article': request.context}


    @view_config(route_name='article', renderer='article.jinja2',
                 context=db.Article)
    def article(request):
        return {'article': request.context}

Et voilá, you can now log in (try *johncleese* and *bugger* as user/pass) and
post comments to existing articles.

.. todo::

    There will more sections covering designing the application.

Footnotes
=========

.. [1] You weren't expecting The Spanish Inquisition, were you?

.. [2] This custom type will always create the correct database type. The
       documentation of the :ref:`database internals <db_internals>` explains
       the rationale behind this type.

