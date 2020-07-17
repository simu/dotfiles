#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import socket
import os
import jinja2
import sys
import shutil

if len(sys.argv) < 3:
    print >>sys.stderr, "Usage: %s siteconfig filesconfig" % sys.argv[0]
    sys.exit(1)

SITECONFIG = os.path.abspath(sys.argv[1])
CONFIG_DIR = os.path.dirname(sys.argv[1])
TEMPLATES = os.path.abspath(sys.argv[2])
GENERATED_DIR = os.environ['OUTPUT_DIRECTORY']

# grab siteconfig from specified file
def load_siteconfig(sitecfg_file):
    with open(sitecfg_file) as sc:
        siteconfig = json.loads(sc.read())
    # inject absolute path of this script as value for "Managed by" blurb
    siteconfig['dotfiles_managed'] = os.path.abspath(sys.argv[0])
    siteconfig['dotfiles_source'] = os.path.abspath(sys.argv[1])
    siteconfig['dotfiles_path'] = os.path.dirname(siteconfig['dotfiles_managed'])
    return siteconfig

# load list of templates
def load_templates(filescfg_file):
    files = []
    with open(filescfg_file) as f:
        # format: list of tuples (srcfile, destfile, mode)
        for line in f:
            source, dest, mode = map(str.strip, line.split(','))
            files.append((source, dest, int(mode, base=0)))
    return files

# render one config file
def generate_config(template_fname, config_fh):
    global siteconfig

    with open(os.path.join(CONFIG_DIR, template_fname)) as f:
        fc = ''.join(f.readlines()).decode('utf-8')

    template = jinja2.Template(fc)

    config_fh.write(template.render(siteconfig).encode('utf-8'))
    config_fh.write('\n')

def set_managed_by(sitecfg, source_found):
    # inject absolute path of this script as value for "Managed by" blurb
    sitecfg['dotfiles_managed'] = os.path.abspath(sys.argv[0])
    if source_found:
        sitecfg['dotfiles_source'] = os.path.abspath(sys.argv[1])
    else:
        sitecfg['dotfiles_source'] = "Template defaults"
    return sitecfg

siteconfig = {}
source_exists=False
if os.path.exists(SITECONFIG):
    siteconfig = load_siteconfig(SITECONFIG)
    source_exists = True
siteconfig = set_managed_by(siteconfig, source_exists)

FILES = load_templates(TEMPLATES)

for src,dest,mode in FILES:
    destfile = os.path.join(GENERATED_DIR, dest)
    with open(destfile, 'w') as f:
        generate_config(src, f)
    os.chmod(destfile, mode)
