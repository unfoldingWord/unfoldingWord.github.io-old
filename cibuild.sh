#!/usr/bin/env bash
set -e # halt script on error

# build site
bundle exec jekyll build

# Run HTML Proofer against built site
bundle exec htmlproofer ./_site --disable-external

