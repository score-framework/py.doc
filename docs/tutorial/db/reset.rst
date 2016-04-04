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

You have just initialized a python interpreter, where your SCORE application is
already initialized. The only thing left to do is initializing your
database:

>>> score.db.create()

This should silently generate all required database entities. We can now
connect to the database and inspect it through the console:

.. code-block:: console

    (moswblog)sirlancelot@spamalot:~/moswblog$ sqlite3 database.sqlite3

.. code-block:: sqlite3

    SQLite version 3.11.1 2016-03-03 16:17:53
    Enter ".help" for usage hints.
    sqlite> .tables
    _article  _blogger  _user     article   blogger   user    
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
    sqlite> .quit

We have a table, as well as a view_ for each class we created earlier. These
:ref:`automatically created views <db_view>` are a feature of the
:mod:`score.db` module. They will make your life easier if you ever have to
mangle with the database manually. They are also the reason why database tables
start with an underscore: The more-readable name without underscore is reserved
for humans.

.. _view: https://en.wikipedia.org/wiki/View_%28SQL%29
