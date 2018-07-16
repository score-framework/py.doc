.. _tutorial_db:

Database
========

We will create a database layer with the use of :mod:`score.sa.orm`, which is built on top of the excellent sqlalchemy_ library. After defining the
python classes, we will also add the connection configuration to our config
file and initialize the app to create our database.

.. toctree::
    :maxdepth: 2

    models
    conf
    reset
    gendummy

.. _sqlalchemy: https://www.sqlalchemy.org/
