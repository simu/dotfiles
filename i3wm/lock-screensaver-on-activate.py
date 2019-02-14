#!/usr/bin/env python2

import dbus, gobject, sys, logging
from dbus.mainloop.glib import DBusGMainLoop

LOGFH=None
LOGFILE="/tmp/screensaver_lock.log"

def screensaver_lock(state):
    obj = bus.get_object("org.mate.ScreenSaver", "/org/mate/ScreenSaver")
    screensaver = dbus.Interface(obj, "org.mate.ScreenSaver")
    lock = screensaver.get_dbus_method("Lock")
    if state:
        if LOG:
            LOG.info("Locking screen on activation")
        try:
            lock(1)
        except dbus.DBusException, e:
            LOG.debug("Trying to lock screen: %s", e)


if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    logFmt=logging.Formatter(fmt='%(asctime)s %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S')
    logHandler=logging.FileHandler(LOGFILE, mode='a')
    logHandler.setFormatter(logFmt)
    LOG = logging.getLogger("screensaver_lock")
    LOG.setLevel(logging.INFO)
    LOG.addHandler(logHandler)
    LOG.info("%s started..." % sys.argv[0])

    bus.add_signal_receiver(screensaver_lock,
                            dbus_interface="org.mate.ScreenSaver",
                            signal_name="ActiveChanged")

    loop = gobject.MainLoop()
    loop.run()
