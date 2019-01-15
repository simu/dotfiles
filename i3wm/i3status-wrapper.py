#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
#
# In its current version it will display the cpu frequency governor, but you
# are free to change it to display whatever you like, see the comment in the
# source code below.
#
# © 2012 Valentin Haenel <valentin.haenel@gmx.de>
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

import sys
import json
import socket
from subprocess import check_output
from mpd import MPDClient

def get_governor():
    """ Get the current governor for cpu0, assuming all CPUs use the same. """
    with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor') as fp:
        return fp.readlines()[0].strip()

def dropbox_installed():
    """Check if dropbox is running"""
    try:
        check_output(["dropbox", "status"])
        return True
    except:
        return False

def get_dropbox_status():
    """ Get current status for dropbox. """
    try:
        out = check_output(["dropbox", "status"])
        return out.strip().replace('\n', '|')
    except:
        return "not installed"

def get_current_kbmap():
    """ Get current keyboard layout """
    try:
        out = check_output(["setxkbmap", "-print"])
        for line in out.splitlines():
            if line.find("symbols") > 0:
                _, layout, _ = line.split('+', 2)
                return layout
        return ""
    except:
        return "cannot parse kbd layout"

def get_current_nuvola_song():
    """ Get nuvolaplayer status """
    def str_to_bool(input):
        return {'true': True, 'false': False}.get(input, False)

    try:
        artist = check_output(["nuvolaplayer3ctl", "track-info", "artist"]).strip()
        title = check_output(["nuvolaplayer3ctl", "track-info", "title"]).strip()
        state = check_output(["nuvolaplayer3ctl", "track-info", "state"]).strip()
        thumbs_up = check_output(["nuvolaplayer3ctl", "action-state", "thumbs-up"]).strip()
        thumbsym = "(+)" if str_to_bool(thumbs_up) else ""

        if state == "playing" or state == "paused":
            return "[%s]%s %s - %s" % (state, thumbsym, artist, title)
        else:
            return "[n/a]"
    except:
        return "[n/a]"
    pass

mpd_client = None
def mpd_reconnect():
    # open mpd connection
    global mpd_client
    mpd_client = MPDClient()
    mpd_client.timeout = 5
    mpd_client.idletimeout = None
    try:
        mpd_client.connect("localhost", 6600)
    except:
        print >>sys.stderr, "could not connect"
        return False

    print >>sys.stderr, "mpd reconnected"
    return True

def get_mpd_song():
    """ Get infos from mpd """
    global mpd_client
    try:
        mpd_client.ping()
    except:
        c = mpd_reconnect()
        if not c:
            return "[mpd: could not reconnect]"
    try:
        mpd_client.command_list_ok_begin()
        mpd_client.update()
        mpd_client.status()
        mpd_client.currentsong()
        results = mpd_client.command_list_end()
        state = results[1]['state']
        artist = None
        if 'artist' in results[2].keys():
            artist = results[2]['artist']
        title = None
        if 'title' in results[2].keys():
            title = results[2]['title']
        if artist is None and title is not None:
            # assume #Musik stream
            artist, title = title.split(" | ")[0].split(" - ")
        if state == "play" or state == "paused":
            return "[%s] %s - %s" % (state, artist, title)
        else:
            return "[n/a]"
    except:
        return "[n/a]"
    pass

def get_running_vms():
    """Get number of currently running libvirt VMs"""
    import libvirt
    conn = libvirt.openReadOnly(None)
    if conn == None:
        return
    return "Online VMs: %d" % conn.numOfDomains()
    pass

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # connect to MPD
    mpd_reconnect()

    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        #j.insert(0, {'full_text' : '%s' % get_governor(), 'name' : 'gov'})
        if dropbox_installed():
            j.insert(0, {'full_text' : 'Dropbox: %s' % get_dropbox_status(), 'name' : 'dropbox'})
        j.insert(0, {'full_text' : 'layout: %s' % get_current_kbmap(), 'name' : 'kbmap'})
        if socket.gethostname().startswith('wyvern'):
            j.insert(0, {'full_text' : get_mpd_song(), 'name' : 'music'})
            #j.insert(0, {'full_text' : get_running_vms(), 'name' : 'vms'})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
