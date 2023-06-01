#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import jinja2, os, sys

confdir = os.path.dirname(os.path.abspath(sys.argv[0]))
homedir = os.environ['HOME']
user    = os.environ['USER']

print(f"Generating puppet manifest for confdir={confdir}, homedir={homedir}, user={user}")

with open(os.path.join(confdir, "dotfiles.pp.jinja"), encoding="utf-8") as tpl:
    template = jinja2.Template(tpl.read())

with open(os.path.join(confdir, "generated", "dotfiles.pp"), 'w', encoding="utf-8") as manifest:
    manifest.write(template.render(confdir=confdir, homedir=homedir, user=user))
    manifest.write('\n')
