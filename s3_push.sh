#!/bin/bash
# -*- coding: utf8 -*-
#
#  Copyright (c) 2015 unfoldingWord
#  http://creativecommons.org/licenses/MIT/
#  See LICENSE file for details.
#
#  Contributors:
#  Jesse Griffin <jesse@distantshores.org>

SRC="/var/www/vhosts/unfoldingword.org/source/"
S3="/var/www/vhosts/unfoldingword.org/s3/"
BKT="s3://unfoldingword.org/"
EXCLUDES="/var/www/vhosts/unfoldingword.org/source/s3_excludes"

/usr/local/bin/jekyll build --source "$SOURCE" --destination "$S3"

s3cmd sync --rr -M --no-mime-magic --delete-removed \
    --exclude-from "$EXCLUDES" \
    --add-header="Cache-Control:max-age=3600" \
    "$SRC" "$BKT"
