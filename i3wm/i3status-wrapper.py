#!/usr/bin/env python3
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
    with open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor") as fp:
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
        return out.strip().replace("\n", "|")
    except:
        return "not installed"


def get_current_kbmap():
    """ Get current keyboard layout """
    try:
        out = check_output(["setxkbmap", "-print"]).decode("utf-8")
        for line in out.splitlines():
            if line.find("symbols") > 0:
                _, layout, _ = line.split("+", 2)
                return layout
        return ""
    except:
        return "cannot parse kbd layout"


def get_current_nuvola_song():
    """ Get nuvolaplayer status """

    def str_to_bool(input):
        return {"true": True, "false": False}.get(input, False)

    try:
        artist = check_output(["nuvolaplayer3ctl", "track-info", "artist"]).strip()
        title = check_output(["nuvolaplayer3ctl", "track-info", "title"]).strip()
        state = check_output(["nuvolaplayer3ctl", "track-info", "state"]).strip()
        thumbs_up = check_output(
            ["nuvolaplayer3ctl", "action-state", "thumbs-up"]
        ).strip()
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
        print("could not connect", file=sys.stderr)
        return False

    print("mpd reconnected", file=sys.stderr)
    return True


def get_mpd_song():
    """ Get infos from mpd """
    global mpd_client
    try:
        mpd_client.ping()
    except:
        c = mpd_reconnect()
        if not c:
            return None
    try:
        mpd_client.command_list_ok_begin()
        mpd_client.update()
        mpd_client.status()
        mpd_client.currentsong()
        results = mpd_client.command_list_end()
        state = results[1]["state"]
        artist = None
        if "artist" in list(results[2].keys()):
            artist = results[2]["artist"]
        title = None
        if "title" in list(results[2].keys()):
            title = results[2]["title"]
        if artist is None and title is not None:
            # assume #Musik stream
            artist, title = title.split(" | ")[0].split(" - ")
        if state == "play" or state == "pause":
            return "[%s] %s - %s" % (state, artist, title)
        else:
            return None
    except:
        return None
    pass


_prev = None


def get_gpmdp_song():
    """Get song from Google Play Desktop Music Player"""
    import os

    global _prev
    _json_info_path = os.path.join(
        os.environ["HOME"],
        ".config",
        "Google Play Music Desktop Player",
        "json_store",
        "playback.json",
    )
    try:
        with open(_json_info_path, "r") as _info_fh:
            _info = json.load(_info_fh)
            if not _info["song"]["title"]:
                _prev = None
                return None
            state = "play" if _info["playing"] else "paused"
            _prev = "[%s] %s - %s" % (
                state,
                _info["song"]["artist"],
                _info["song"]["title"],
            )
            return _prev
    except:
        return _prev


def _libvirt_get_running_vms():
    """Get number of currently running libvirt VMs"""
    try:
        import libvirt
    except:
        print("No libvirt installed", file=sys.stderr)
        return None
    conn = None
    try:
        conn = libvirt.openReadOnly(None)
    except:
        return None
    if conn == None:
        return None
    return "libvirt VMs: %d" % conn.numOfDomains()


def _vbox_get_running_vms():
    """Get number of running vbox VMs"""
    vbox_listrunningvms = None
    try:
        vbox_listrunningvms = check_output(["vboxmanage", "list", "runningvms"]).decode(
            "utf-8"
        )
    except CalledProcessError as e:
        print("check_output(['vboxmanage', ...]):", file=sys.stderr)
        e.print_stack_trace()
        return None
    if vbox_listrunningvms is None:
        return None
    vbox_listrunning_lines = vbox_listrunningvms.strip().split("\n")
    if vbox_listrunning_lines[0] == "":
        return "VBox VMs: 0"
    return "VBox VMs: %d" % len(vbox_listrunning_lines)


def get_running_vms(j):
    """Get number of running VMs (all providers)"""
    libvirt_msg = _libvirt_get_running_vms()
    vbox_msg = _vbox_get_running_vms()
    if libvirt_msg:
        j.insert(0, {"full_text": libvirt_msg, "name": "libvirt_vms"})
    if vbox_msg:
        j.insert(0, {"full_text": vbox_msg, "name": "vbox_vms"})


def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + "\n")
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


if __name__ == "__main__":
    # connect to MPD
    mpd_reconnect()

    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""
        # ignore comma at start of lines
        if line.startswith(","):
            line, prefix = line[1:], ","

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        # j.insert(0, {'full_text' : '%s' % get_governor(), 'name' : 'gov'})
        if dropbox_installed():
            j.insert(
                0,
                {"full_text": "Dropbox: %s" % get_dropbox_status(), "name": "dropbox"},
            )
        j.insert(0, {"full_text": "layout: %s" % get_current_kbmap(), "name": "kbmap"})
        if socket.gethostname().split(".")[0] in ["wyvern", "phoenix"]:
            mpd_msg = get_mpd_song()
            if mpd_msg:
                j.insert(0, {"full_text": mpd_msg, "name": "mpd"})
            gpmdp_msg = get_gpmdp_song()
            if gpmdp_msg:
                j.insert(0, {"full_text": gpmdp_msg, "name": "gpmdp"})
            get_running_vms(j)
        # and echo back new encoded json
        print_line(prefix + json.dumps(j))
