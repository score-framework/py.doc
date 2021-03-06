.. _tutorial_db_gendummy:

Dummy Data
----------

Since we have a working database now, we should insert some data to work with.
We have prepared some data for your convenience, that you can load from an URL:

>>> from score.init import init_from_file
>>> from score.sa.orm import load_data
>>> score = init_from_file('dev.conf')
>>> objects = load_data('http://score-framework.org/doc/_downloads/moswblog.yaml')
>>> session = score.orm.Session()
>>> for cls in objects:
...     for id in objects[cls]:
...         session.add(objects[cls][id])
...         
>>> session.commit()

We can now inspect the objects in our database again:


.. code-block:: console

    $ sqlite3 database.sqlite3

.. code-block:: sqlite3

    sqlite> select * from user;
    mrteabag|$pbkdf2-sha512$25000$0npPydlbi9G6V4rRulfKGQ$ackN6Vr78z/VWXxXX1CbC2RS9XdN9tmkJFv9KkhGWgQo2ePLQ.RNDcbniyiE34k0fmIrzz7ujUDP/h0ucdQ2mg|blogger|1
    mrtwolumps|$pbkdf2-sha512$25000$rrWWsnaOsRYi5Pxfi1FK6Q$/cawb6oIoGvmFBtQ5NtfB1BWryJ6WLgccodG/tsiiFvZEdRS7RIwy78cW0uxfp5U5UggHS3Xg3IxOTtjhzibwA|blogger|2
    boondogglegames|$pbkdf2-sha512$25000$ZIxxTikFwNibMwZAKMXYmw$noj7.Ha/UFDDBFLwjJPWnZJ/V4wP4xqSyR2cm5SFvc/KTF7kTbf3.00Gq2ENFbaYO.rFlZuFSpOXXEHy1sNXpA|blogger|3
    sqlite> .quit

Alright, now we have some data to work with! But that was a lot of typing and
we would like to avoid all that the next time. It would be a good idea to
:ref:`write a shell command <tutorial_cli>` that will do all this.

