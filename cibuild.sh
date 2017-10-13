#!/usr/bin/env bash
set -e # halt script on error

# Run Markdown Proofer against source files
bundle exec mdl ./pages -r MD001,MD003,MD004,MD005,MD006,MD007,MD009,MD010,MD011,MD012,MD014,MD018,MD019,MD020,MD021,MD022,MD023,MD024,MD025,MD027,MD028,MD029,MD030,MD031,MD032,MD037,MD038,MD039

# Get manifest files
_data/content/get_manifests.sh

# Build site
bundle exec jekyll build

# Run HTML Proofer against built site
# Prefers to check against a local assets folder if available,
# otherwise it will check against the test S3 bucket.
if [ -d ./_site/assets ]; then
  bundle exec htmlproofer ./_site --disable-external --assume-extension --check-html --allow-hash-href --url-ignore /.*\/slides\/.*/ --alt-ignore /.*\/ta/jpg\/.*/
else
  bundle exec htmlproofer ./_site --disable-external --assume-extension --check-html --allow-hash-href --url-ignore /.*\/slides\/.*/ --url-swap "\/assets\/.*:http://test-unfoldingword.org.s3-website-us-west-2.amazonaws.com/assets/"
fi

# Show files in _site directory
echo "Running ls -lh _site/en/"
ls -lh _site/en/
