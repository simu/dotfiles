#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import socket
import os
import jinja2
import sys

config_dir = os.path.dirname(sys.argv[0])

siteconfig = os.path.join(config_dir, "i3."+socket.gethostname()+".config")
with open(siteconfig) as sc:
    siteconfig = json.loads(sc.read())

with open(os.path.join(config_dir, "i3.config.jinja")) as f:
    fc = ''.join(f.readlines()).decode('utf-8')

template = jinja2.Template(fc)

with open(os.path.join(os.environ['HOME'], ".i3", "config"), 'w') as c:
    c.write(template.render(siteconfig).encode('utf-8'))
    c.write('\n')
