.. _tutorial_initialization:

**************
Initialization
**************

A SCORE application always starts out by initializing all its modules. This
step weeds out configuration issues early and allows getting heavy-weight
operations out of the way before the actual application workflow starts.

.. figure:: init.png
    :alt: The SCORE Initialization process in a nutshell

    The SCORE Initialization process in a nutshell

Since your SCORE application is also a SCORE module, it is expected to
initialize just like all other modules. The only requirement for this that your
module provides a function called ``init``:

- This function must accept a dictionary as its first argument, containing
  your module's configuration (this is the so-called :term:`confdict`). The
  confdict contains nothing but strings, but your init function can make use
  of the various parsing functions in :mod:`score.init` (like :func:`parse_bool
  <score.init.parse_bool>` and :func:`parse_object <score.init.parse_object>`)
  to interpret them.

- The other parameters to this function are your module's dependencies, i.e.
  names of other modules that your module relies on. A module for
  transporting coconuts (depending on the *swallow* module, optionally making
  use of an existing *knights* module) might look like the following:

  .. code-block:: python

    from score.init import parse_time_interval

    def init(confdict, swallow, knights=None):
        max_coconut_weight = int(confdict.get('max_weight', 10))
        assert swalllow.max_payload_weight >= max_coconut_weight
        timeout = parse_time_interval(confdict.get('assume_dead', '1d'))
        return ConfiguredCoconutModule(max_coconut_weight, timeout)

- Finally, your ``init`` function must return an instance of
  :class:`score.init.ConfiguredModule` containing a configured instance of
  your module. This object will be used to represent your module throughout
  the rest of the application:

  .. code-block:: python

    from score.init import ConfiguredModule

    class ConfiguredCoconutModule(ConfiguredModule):

        def __init__(self, max_coconut_weight, timeout):
            import coconut
            super().__init__(coconut)
            self.max_coconut_weight = max_coconut_weight
            self.timeout = timeout

        def estimate_delivery_time(self, swallow, from, to):
            # TODO: do some real calculations here
            return 42

That's all there is to know! Now let's create an example application using this
information. To the :ref:`blog tutorial <tutorial>`!
