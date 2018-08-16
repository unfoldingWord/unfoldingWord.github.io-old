#!/usr/bin/env bash
# -*- coding: utf8 -*-
#
#  Copyright (c) 2017 unfoldingWord
#  http://creativecommons.org/licenses/MIT/
#  See LICENSE file for details.
#
#  Contributors:
#  Jesse Griffin <jesse@unfoldingword.org>

SOURCE="_site/assets/"
EXCLUDES="s3_excludes"

echo "Note: Assets will not be deleted from S3"
echo "Assets will be synced from $SOURCE"
read -p "Sync assets to test and prod? <Ctrl-C to break>"

BKT="s3://dev.unfoldingword.bible/assets/"
echo "Syncing to $BKT"
s3cmd -c s3cfg-prod sync -M -F --no-mime-magic \
    --exclude-from "$EXCLUDES" \
    --add-header="Cache-Control:max-age=600" \
    "$SOURCE" "$BKT"

BKT="s3://unfoldingword.bible/assets/"
echo "Syncing to $BKT"
s3cmd -c s3cfg-prod sync -M -F --no-mime-magic \
    --exclude-from "$EXCLUDES" \
    --add-header="Cache-Control:max-age=600" \
    "$SOURCE" "$BKT"

