#!/usr/bin/env bash
# -*- coding: utf8 -*-
#
#  Copyright (c) 2017 unfoldingWord
#  http://creativecommons.org/licenses/MIT/
#  See LICENSE file for details.
#
#  Contributors:
#  Jesse Griffin <jesse@unfoldingword.org>

SOURCE="_site/"
BKT="s3://unfoldingword.org/"
EXCLUDES="s3_excludes"

openssl aes-256-cbc -K $encrypted_e2db0eb08244_key -iv $encrypted_e2db0eb08244_iv -in secrets.tar.enc -out secrets.tar -d
tar xvf secrets.tar

s3cmd -c s3cfg-prod sync --rr -M -F --dry-run \
    --no-mime-magic --delete-removed \
    --exclude-from "$EXCLUDES" \
    --add-header="Cache-Control:max-age=600" \
    "$SOURCE" "$BKT"
