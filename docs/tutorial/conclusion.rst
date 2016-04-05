.. _tutorial_conclusion:

Conclusion
==========

We have created a very small application demonstrating the key concepts of The
SCORE Framework. Perhaps the most interesting aspect of this application is its
modularity and the resulting flexibility:

We started out with a model definition, added shell access, and implemented a
web application on top of that. We could have just skipped the http layer and
written a nice CLI application instead. It would have been equally easy to
implement a completely different user interface to the underlying data, like
text-to-speech.


.. _tutorial_further_reading:

Further Reading
===============

We have a score of good modules for web development, which might be of interest
to you:

- :mod:`score.tpl`: Templating, like with jinja_.
- :mod:`score.html`: Adds HTML support to *score.tpl*
- :mod:`score.webassets`: Manages assets like css and javacsript
- :mod:`score.css`: SASS and css assets helper
- :mod:`score.js`: Javascript helper
- :mod:`score.jsapi`: Python-Javascript bridge

And here are some interesting modules that are not strictly for web
development:

- :mod:`score.es`: Elasticsearch integration
- :mod:`score.netfs`: Distributed file system
- :mod:`score.kvcache`: Access to various key/value storage engines
- :mod:`score.distlock`: Distributed Mutex implementation

.. _jinja: http://jinja.pocoo.org/docs/dev/
