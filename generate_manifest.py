#!/usr/bin/env python
# -*- coding: utf-8 -*-

import jinja2, os, sys

confdir = os.path.dirname(os.path.abspath(sys.argv[0]))
homedir = os.environ['HOME']
user    = os.environ['USER']

print "Generating puppet manifest for confdir=%s, homedir=%s, user=%s" % (confdir, homedir, user)

with open(os.path.join(confdir, "dotfiles.pp.jinja")) as tpl:
    template = jinja2.Template(tpl.read().decode('utf-8'))

with open(os.path.join(confdir, "generated", "dotfiles.pp"), 'w') as manifest:
    manifest.write(template.render(confdir=confdir, homedir=homedir, user=user).encode('utf-8'))
    manifest.write('\n')
