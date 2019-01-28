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

siteconfig = os.path.join(CONFIG_DIR, "i3."+socket.gethostname()+".config")
with open(siteconfig) as sc:
    siteconfig = json.loads(sc.read())

def generate_config(template_fname, config_fh):
    global siteconfig

    with open(os.path.join(CONFIG_DIR, template_fname)) as f:
        fc = ''.join(f.readlines()).decode('utf-8')

    template = jinja2.Template(fc)

    config_fh.write(template.render(siteconfig).encode('utf-8'))
    config_fh.write('\n')

# i3 config
with open(os.path.join(GENERATED_DIR, "i3config"), 'w') as c:
    generate_config("i3.config.jinja", c)

# dunst config
with open(os.path.join(GENERATED_DIR, "dunstrc"), 'w') as dunstc:
    generate_config("dunstrc.jinja", dunstc)

# smart terminal customization pass
smartterm_bin = os.path.join(GENERATED_DIR, "i3-smart-terminal")
with open(smartterm_bin, 'w') as i3smartterm:
    generate_config("i3-smart-terminal.jinja", i3smartterm)
os.chmod(smartterm_bin, 0755)
