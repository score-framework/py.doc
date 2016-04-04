.. _tutorial_db_models:

Database Models
---------------

Let's add the users first as ``blog/db/user.py``:

.. code-block:: python
    :linenos:
    :emphasize-lines: 1,5

    from .storable import Storable
    from sqlalchemy import Column, String
    from sqlalchemy_utils.types.password import PasswordType

    class User(Storable):
        username = Column(String(100), nullable=False)
        password = Column(PasswordType(schemes=['pbkdf2_sha512']))

    class Blogger(User):
        pass

As you can see, we are making use of the base class, that we created earlier.
The *Blogger* class does not contain any members yet, but will give us a clear
distinction between normal users and those who are allowed to write articles.

The next file is the one containing the blogs and articles and is called
``blog/db/article.py``:

.. code-block:: python
    :linenos:
    :emphasize-lines: 4,9

    from .storable import Storable
    from score.db import IdType
    from sqlalchemy import Column, String, ForeignKey
    from sqlalchemy.orm import relationship


    class Article(Storable):
        author_id = Column(IdType, ForeignKey('_blogger.id'), nullable=False)
        author = relationship('Blogger')
        title = Column(String(200), nullable=False)
        teaser = Column(String, nullable=False)
        body = Column(String, nullable=False)


This time, we are using a nice feature of sqlalchemy: relationships. Every
*Article* has an author, which has to be a *User*. So we have to create a column
referencing that table. We will call this column *author_id*, so we can later
create a member *author*, which contains the actual object.  

The *author_id* consists of a single id field, which we configure with a
`foreign key`_ reference to the table containing our users. The name of a table
is automatically generated by converting the CamelCased class name to the same
name separated_by_underscores and prefixing it with an additional underscore.

The reason for the additional leading underscore will be evident, once we
create and inspect the database. But before that, we will first have to
:ref:`configure our database <tutorial_db_conf>`.

.. _foreign key: https://en.wikipedia.org/wiki/Foreign_key