#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import socket
import os
import jinja2
import sys
import shutil

config_dir = os.path.dirname(sys.argv[0])

siteconfig = os.path.join(config_dir, "i3."+socket.gethostname()+".config")
with open(siteconfig) as sc:
    siteconfig = json.loads(sc.read())

def generate_config(template_fname, config_fh):
    global siteconfig

    with open(os.path.join(config_dir, template_fname)) as f:
        fc = ''.join(f.readlines()).decode('utf-8')

    template = jinja2.Template(fc)

    config_fh.write(template.render(siteconfig).encode('utf-8'))
    config_fh.write('\n')

with open(os.path.join(os.environ['HOME'], ".i3", "config"), 'w') as c:
    generate_config("i3.config.jinja", c)

dunst_confdir = os.path.join(os.environ['HOME'], ".config", "dunst")
try:
    os.makedirs(dunst_confdir, 0755)
except:
    pass
with open(os.path.join(dunst_confdir, "dunstrc"), 'w') as dunstc:
    generate_config("dunstrc.jinja", dunstc)
