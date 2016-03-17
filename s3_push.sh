#!/bin/bash
# -*- coding: utf8 -*-
#
#  Copyright (c) 2016 unfoldingWord
#  http://creativecommons.org/licenses/MIT/
#  See LICENSE file for details.
#
#  Contributors:
#  Jesse Griffin <jesse@unfoldingword.org>

S3="/var/www/vhosts/unfoldingword.org/s3/"
BKT="s3://unfoldingword.org/"
EXCLUDES="/var/www/vhosts/unfoldingword.org/source/s3_excludes"

s3cmd sync --rr -M --no-mime-magic --delete-removed \
    --exclude-from "$EXCLUDES" \
    --add-header="Cache-Control:max-age=600" \
    "$S3" "$BKT"
