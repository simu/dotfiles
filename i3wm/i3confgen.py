#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import socket
import os
import jinja2
import sys
import shutil

CONFIG_DIR = os.path.dirname(sys.argv[0])
GENERATED_DIR = os.environ['OUTPUT_DIRECTORY']

FILES =[ ("i3.config.jinja", "i3config", 0644),
         ("dunstrc.jinja", "dunstrc", 0644),
         ("networkmanager-dmenu.ini.j2", "networkmanager-dmenu.ini", 0644),
         ("xautolock.sh.jinja", "xautolock.sh", 0755),
         ("i3-smart-terminal.jinja", "i3-smart-terminal", 0755) ]

siteconfig = os.path.join(CONFIG_DIR, "i3."+socket.gethostname()+".config")
with open(siteconfig) as sc:
    siteconfig = json.loads(sc.read())

siteconfig['dotfiles_managed'] = os.path.abspath(sys.argv[0])

def generate_config(template_fname, config_fh):
    global siteconfig

    with open(os.path.join(CONFIG_DIR, template_fname)) as f:
        fc = ''.join(f.readlines()).decode('utf-8')

    template = jinja2.Template(fc)

    config_fh.write(template.render(siteconfig).encode('utf-8'))
    config_fh.write('\n')


for src,dest,mode in FILES:
    destfile = os.path.join(GENERATED_DIR, dest)
    with open(destfile, 'w') as f:
        generate_config(src, f)
    os.chmod(destfile, mode)
