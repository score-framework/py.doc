.. _tutorial_db_reset:

Database Reset
--------------

Now that we have defined all our classes, we need to create the database
tables, views, foreign keys, triggers, etc. We will use a command-line
access to our application for this purpose:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ score shell
    Python 3.4.3 (default, Jan  8 2016, 11:18:01) 
    [GCC 5.3.0] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    (InteractiveConsole)
    >>>

You have just initialized a python interpreter where your SCORE application is
already initialized. The only thing left to do is initializing your
database:

>>> score.db.create()

This should silently generate all required database entities. We can now
connect to the database and inspect it through the console:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ sqlite3 database.sqlite3
    SQLite version 3.11.1 2016-03-03 16:17:53
    Enter ".help" for usage hints.
    sqlite>

Let's first look at the tables and views:

.. code-block:: sqlite3

    sqlite> .tables
    _article  _blogger  _user     article   blogger   user    
    sqlite> .schema _user
    CREATE TABLE _user (
        username VARCHAR(100) NOT NULL, 
        password VARBINARY(1137), 
        _type VARCHAR(100) NOT NULL, 
        id INTEGER NOT NULL, 
        PRIMARY KEY (id)
    );

We have a table, as well as a view_ for each class we created earlier. These
:ref:`automatically created views <db_view>` are a feature of the
:mod:`score.db` module. They will make your life easier whenever you ever have
to meddle with the database manually. They are also the reason why database tables
start with an underscore: The more-readable name without the leading underscore
is reserved for humans, where all members of all parent classes are aggregated
into a convenient view.

.. code-block:: sqlite3

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
    sqlite> .schema blogger
    CREATE VIEW "blogger" AS SELECT _user.password, _user._type, _blogger.id, _user.username 
    FROM _blogger JOIN _user ON _user.id = _blogger.id;

When you're done rejoicing in your marvellous database setup, you can leave
your sqlite shell with a simple `.quit` command …

.. code-block:: sqlite3

    sqlite> .quit

… and head over to the next section to :ref:`fill your database with some data
<tutorial_db_gendummy>`.

.. _view: https://en.wikipedia.org/wiki/View_%28SQL%29
