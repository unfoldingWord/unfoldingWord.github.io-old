#!/usr/bin/env bash
set -e # halt script on error

# Run Markdown Proofer against source files
bundle exec mdl ./pages -r MD001,MD003,MD004,MD005,MD006,MD007,MD009,MD010,MD011,MD012,MD014,MD018,MD019,MD020,MD021,MD022,MD023,MD024,MD025,MD027,MD028,MD029,MD030,MD031,MD032,MD037,MD038,MD039

# Build site
bundle exec jekyll build

# Run HTML Proofer against built site
# Prefers to check against a local assets folder if available,
# otherwise it will check against the test S3 bucket.
if [ -d ./_site/assets ]; then
  bundle exec htmlproofer ./_site --disable-external --assume-extension --check-html --allow-hash-href --file-ignore ./_site/academy/ta-intro.html,./_site/academy/ta-process.html,./_site/academy/ta-translation-2.html,./_site/gaj-x-ymnk/slides/360px/37/index.html,./_site/gaj-x-ymnk/slides/360px/18/index.html,./_site/gaj-x-ymnk/slides/2160px/37/index.html,./_site/gaj-x-ymnk/slides/2160px/18/index.html --alt-ignore /.*\/ta/jpg\/.*/
else
  bundle exec htmlproofer ./_site --disable-external --assume-extension --check-html --allow-hash-href --file-ignore ./_site/academy/ta-intro.html,./_site/academy/ta-process.html,./_site/academy/ta-translation-2.html,./_site/gaj-x-ymnk/slides/360px/37/index.html,./_site/gaj-x-ymnk/slides/360px/18/index.html,./_site/gaj-x-ymnk/slides/2160px/37/index.html,./_site/gaj-x-ymnk/slides/2160px/18/index.html --alt-ignore /.*\/ta/jpg\/.*/ --url-swap "\/assets\/.*:http://test-unfoldingword.org.s3-website-us-west-2.amazonaws.com/assets/"
fi

# Show files in _site directory
echo "Running ls -lh _site/en/"
ls -lh _site/en/
