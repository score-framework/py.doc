.. _devguide_philosophy:

Development Philosophy
======================

Over time, we have become very accustomed to build our own layers on top of
others'. Whenever we need to expand an existing eco-system, we always strive
to add and use existing mechanisms, and never to remove. This is not always
possible, but whenever we see an opportunity to improve an existing
eco-system, we always try to expand it using its own mechanisms first, before
we decide to work around existing features.

Here are some examples to illustrate what this means for us:

- Our :mod:`database module <score.db>` will make some default decisions for
  you regarding inheritance. In our opinion, a developer should not spend a
  single precious moment thinking whether and how the class he is writing
  should implement sub-classing in the database.

  Under the hood, though, the database module uses the features of sqlalchemy
  designated for exactly these things: it will set the correct
  ``__mapper_args__`` to make sqlalchemy implement the inheritance correctly.
  This feature can be overridden simply by providing the ``__mapper_args__``
  within the class — just as if you were working in a project that has no
  ``score`` dependencies at all!

- The :mod:`templating module <score.tpl>` integrates seamlessly with
  pyramid's rendering system. Any combination of file extensions you register
  in the :func:`tpl configuration <score.tpl.init>`, is automatically
  registered with pyramid.
  
  The next code block will be executed correctly by pyramid, although we never
  explicitly registered ``.jinja2`` files with pyramid; the tpl module did
  that automatically. You can use them, as if there was no ``score`` at all:

  .. code-block:: python

      @view_config('test', renderer='test.jinja2')
      def test(request):
          return {}

- If someone knows a library well, he should feel completely comfortable using
  our extensions. So if someone knows jinja_, or compass_, or pyramid_, … , he
  should immediatly feel at home, even if he encounters some new features.

  .. _jinja: http://jinja.pocoo.org/docs/dev/
  .. _compass: http://compass-style.org/
  .. _pyramid: http://docs.pylonsproject.org/projects/pyramid/en/latest/

