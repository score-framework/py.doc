.. _tutorial_db_models:

Database Models
---------------

Create the file ``moswblog/db.py`` with the following content:

.. code-block:: python

  from score.sa.orm import create_base
  from sqlalchemy import Column, String
  from sqlalchemy_utils.types.password import PasswordType

  Storable = create_base()


  class User(Storable):
      username = Column(String(100), nullable=False)
      password = Column(PasswordType(schemes=['pbkdf2_sha512']))


  class Blogger(User):
      pass

  class Article(Storable):
      author_id = Column(IdType, ForeignKey('_blogger.id'), nullable=False)
      author = relationship('Blogger')
      title = Column(String(200), nullable=False)
      teaser = Column(String, nullable=False)
      body = Column(String, nullable=False)

The base class ``Storable`` represents a bunch of classes that reside inside
the same database. If we had two distinct databases, we would need to create
two different base classes.

The *Blogger* class does not contain any members yet, but will give us a clear
distinction between normal users and those who are allowed to write articles.

The next step is to :ref:`expand the moswblog configuration file
<tutorial_db_conf>` to include the :mod:`score.sa.orm` module.
