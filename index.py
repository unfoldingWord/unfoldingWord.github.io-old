#!/usr/bin/env python
# Copied from git@github.com:Door43/flask-github-webhook.git

import os
import sys
import json
import requests
import ipaddress
from flask import Flask, request, abort
sys.path.append('/var/www/vhosts/door43.org/tools/general_tools')
try:
    from git_wrapper import *
except:
    print "Please verify that"
    print "/var/www/vhosts/door43.org/tools/general_tools exists."
    sys.exit(1)

app = Flask(__name__)
reposfile = '/var/www/vhosts/unfoldingword.org/repos.json'
# Store the IP address blocks that github uses for hook requests.
try:
    hook_blocks = requests.get('https://api.github.com/meta').json()['hooks']
except KeyError:
    hook_blocks = [ u'192.30.252.0/22', u'127.0.0.1/32']
hook_blocks.append(u'127.0.0.1/32')

if os.path.exists(reposfile):
    repos = json.loads(open(reposfile, 'r').read())
else:
    repos = {}


@app.route("/", methods=['GET', 'POST'])
def index():

    if request.method == 'GET':
        return 'OK'

    elif request.method == 'POST':
        # Check if the POST request if from github.com
        for block in hook_blocks:
            ip = ipaddress.ip_address(u'%s' % request.remote_addr)
            if ipaddress.ip_address(ip) in ipaddress.ip_network(block):
                break #the remote_addr is within the network range of github
        else:
            abort(403)

        if request.headers.get('X-GitHub-Event') == "ping":
            return json.dumps({'msg': 'Hi!'})
        if request.headers.get('X-GitHub-Event') != "push":
            return json.dumps({'msg': "wrong event type"})

        payload = json.loads(request.data)
        repo_name = payload['repository']['full_name']
        if repo_name in repos:
            local_path = repos[repo_name]
        else:
            abort(404)

        if not os.path.exists(local_path):
            os.makedirs(local_path, 0755)
            gitClone(local_path, 'git@github.com:{0}.git'.format(repo_name))
            return 'Cloned repo'

        gitPull(local_path)

        if os.path.exists('{0}/publish'.format(local_path)):
            out, ret = runCommand('{0}/s3_push.sh'.format(local_path))
            if ret > 0:
                return 'Publish failed'
            return 'Publish succeeded'

        return 'OK'


if __name__ == "__main__":
    try:
        port_number = int(sys.argv[1])
    except:
        port_number = 80
    is_dev = os.environ.get('ENV', None) == 'dev'
    if os.environ.get('USE_PROXYFIX', None) == 'true':
        from werkzeug.contrib.fixers import ProxyFix
        app.wsgi_app = ProxyFix(app.wsgi_app)
    app.run(host='0.0.0.0', port=port_number, debug=is_dev)
