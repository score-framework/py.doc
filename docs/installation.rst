.. _score_install:

************
Installation
************

.. _score_install_quickstart:

Quickstart
==========

- :ref:`Install python 3 <score_install_python>`

- :ref:`Install a C compiler <score_install_c_compiler>` (for libsass integration)

- :ref:`Install virtualenvwrapper <score_install_virtualenvwrapper>`
  
- :ref:`Create a virtual environment <score_create_virtualenv>`::

    mkvirtualenv --python="$(which python3)" <projectname>

- :ref:`Install our pyramid helpers <score_install_pyramid_helpers>`::

    pip install score.pyramid

  .. todo::

      Since we do not have an open source license yet, we could not publish
      the framework on pypi_. Please use the following shell code instead of
      ``pip install score.pyramid``::

          for i in init kvcache ctx session auth db webassets tpl html css js svg cli pyramid; do
              hg clone https://hg.strg.at/score/py/$i /tmp/$i
              cd /tmp/$i
              python setup.py develop
              cd -
          done

      .. _pypi: http://pypi.python.org

- :ref:`Create the project skeleton <score_install_skeleton>`::

    pcreate -t score <projectname>

- Install the newly created package::

    cd <projectname>
    python setup.py develop

- You are ready to :ref:`run your application <score_install_run>`::

    pserve --reload development.ini

- Head over to the :ref:`blog tutorial <blog_tutorial>`, if you are new to score.

.. _score_install_python:

Install Python 3
================

There are currently two maintained branches of Python:

- The old python2, which is no longer developed, but still receives bug-fixes
  and security updates, and
- The new python3, which is the active branch where new features are added.

``score`` only works on newer python versions, so you might need to update your
system. You can open up a terminal and enter the following command to test if
you have the python 3::

  python3

If the above command fails with an error, you will need to `download and install
python3`_.

.. _download and install python3: https://www.python.org/downloads/

.. _score_install_c_compiler:

Installing a C compiler
=======================

The Python module providing :ref:`SASS <score_sass>` support is written in C,
so we need a working C compiler (like gcc_ or clang_).

- On *MacOS X*, everything should already be in place. But if you experience
  problems installing ``libsass``, you will have to download and install
  XCode_.

- On *Debian* or *Ubuntu*, you can issue the following command to install all
  required packets::

      sudo apt-get install build-essential python3-dev

.. _XCode: https://developer.apple.com/xcode/downloads/
.. _gcc: http://en.wikipedia.org/wiki/GNU_Compiler_Collection
.. _clang: http://en.wikipedia.org/wiki/Clang

.. _score_install_virtualenvwrapper:

Installing virtualenvwrapper
============================

When working on python projects, it is always a good idea to create a new
virtual python environment. If this concept is new to you, please consult the
:ref:`python documentation on virtual environments <python:venv-def>`.

Although python provides its own :mod:`virtual envirenment package
<venv>` starting from version 3.3, its implementation is quite simple. One
notable shortcoming for our use cases is the lack of a package installer in
the created virtual environments. So one needs to manually install one within
the environment.

There is another popular python package that provides more features:
virtualenv_. This project is quite old and very stable, and if you already
know it, you can just use it.

But if you are new in python land, we would rather recommend using
virtualenvwrapper_. It allows more convenient management of multiple virtual
environments and provides hooks for various events — like the activation of a
virtual environment. It is a bit "quirky" to install, though.

Ubuntu / Debian
---------------

.. code-block:: console

  $ aptitude install python3-pip
  $ pip3 install virtualenvwrapper
  $ cat >> .bashrc <<EOF
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/projects
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
  source /usr/local/bin/virtualenvwrapper.sh
  EOF

Mac OS X
--------

.. code-block:: console

  $ pip3 install virtualenvwrapper
  $ cat >> .bash_profile <<EOF
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/Projects
  export VIRTUALENVWRAPPER_PYTHON="$(which python3)"
  source /Library/Frameworks/Python.framework/Versions/3.?/bin/virtualenvwrapper.sh
  EOF

.. _virtualenv: https://pypi.python.org/pypi/virtualenv
.. _virtualenvwrapper: https://pypi.python.org/pypi/virtualenvwrapper
.. _official python package index: https://pypi.python.org

.. _score_create_virtualenv:

Creating a virtual environment
==============================

Creating a virtual environment is as easy as invoking a single script::

  mkvirtualenv --python="$(which python3)" <projectname>

The created virtual environment will have configured pip_ and easy_install_,
as described above. Note that virtualenvwrapper_ immediately activates newly
created virtual environments, as indicated by the name of the virtual
environment at the start of your prompt.

If you want close your current shell and want to continue working on the
project you have just created at a later point, you will need to *activate* its
virtual environment. This is done by calling ``workon``::

  workon <projectname>

It is possible to further configure the environment by adding more features to
the hooks. One popular feature is the automatic switch to the project folder
upon activation. If you want, you can just append the command to the
post-activation file (:file:`~/.virtualenvs/<venv-name>/bin/postactivate`, if
you followed the virtualenvwrapper_ installation above)::

  cd ~/path/to/project/folder

You will now change to that folder automatically whenever you ``workon`` this
virtual environment.

.. _pip: http://pip.readthedocs.org/en/latest
.. _easy_install: http://pythonhosted.org//setuptools/easy_install.html

.. _score_install_pyramid_helpers:

Installing our pyramid helpers
==============================

Pyramid's preferred way of creating new projects is through the usage of
so-called :term:`scaffolds <pyramid:scaffold>`. It's narrative documentation
describes the process of :ref:`creating a new pyramid application
<pyramid:project_narr>` in detail.

We provide a python package containing several scaffolds for applications
using our framework. The package can be installed conveniently using pip_ or
easy_install_::

  pip install score.pyramid
  # the same using easy_install:
  easy_install score.pyramid

.. todo::

    Since we do not have an open source license yet, we could not publish
    the framework on pypi_. Please use the following shell code instead of
    ``pip install score.pyramid``::

        for i in init kvcache ctx session auth db webassets tpl html css js svg cli pyramid; do
            hg clone https://hg.strg.at/score/py/$i /tmp/$i
            cd /tmp/$i
            python setup.py develop
            cd -
        done

    .. _pypi: http://pypi.python.org

.. _score_install_skeleton:

Creating a project skeleton
===========================

As described in detail in pyramid's own documentation on :ref:`creating new
projects <pyramid:creating_a_project>`, the only required call is the
following::

  pcreate -t <scaffold-name> <project-name>

Our :mod:`score.pyramid` package currently provides two scaffolds:

- ``score`` - The default scaffold installing templating features and database
  connectivity.
- ``score-nodb`` - An alternative scaffold providing templating only.

.. _score_install_run:

Running your application
========================

:ref:`Starting a pyramid application <running_the_project_application>` is as
easy as calling ``pserve`` with the path to a configuration file::

  pserve development.ini

Adding the optional argument ``--reload`` will cause the application to
restart whenever a file changes::

  pserve --reload development.ini

Your application is then available under the URL ``http://localhost:6543/``
and you can start your development process.


