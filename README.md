master | [![Build Status](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io.svg?branch=master)](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io)

develop | [![Build Status](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io.svg?branch=develop)](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io)

# unfoldingWord.org

Source for the unfoldingWord.org website.

## Developer Setup

### Installation

To setup a development environment for developing on this site, you need to run the following commands (after cloning this repo):

    cd unfoldingWord.github.io
    bundle install

If you do not have the `bundle` executable, then you'll need to run `sudo gem install bundle` first.  You may also need to run `sudo apt-get install libz-dev ruby-dev` in order to satisfy all dependencies.

### Updating dependencies

    bundle update

### How to run site locally without building the OBS slide shows

An alternate config file has been added that will skip generating the OBS slide show.  Use the `--config` command line parameter to activate this configuration.

    jekyll serve --no-watch --config=_config_skip_obs.yml

### Publishing Setup

There are two branches that are built and deployed to S3 by Travis CI:

* `develop`
* `master`

The develop branch may be seen online at http://test-unfoldingword.org.s3-website-us-west-2.amazonaws.com.

The master branch is available at https://unfoldingword.org.

#### Pre Production Testing

You may run `make test`, or `make build`, or `make serve` to test and review your changes locally.  Once the `cibuild.sh` script passes successfully locally, you may commit and push to the `develop` branch.  You can do this by running `make commit`.

#### Push to Production

If Travis CI has built and deployed the `develop` branch successfully, you may merge it into the `master` branch.  You can do this by running `make publish`.  Your changes should be visible within 5 minutes on https://unfoldingword.org.

#### OBS Publishing

Please note, you *must* add an entry to the "keep_files" directive in `_config.yml` when you want to add a new language for OBS.

#### Syncing Assets

The /assets directory is currently managed by a Resilio Sync folder shared among the developers (ask if you need access).  However, in order to synchronize these assets to the test and production S3 buckets you **must run** `make assets`.  This process will **not remove** assets from the /assets folder, only add or update existing files.

### Custom YAML Values

* header_image: Used as the src for an img tag
* header_image_layout: Currently the only value supported is 'icon'
* header_title: The text for the page H1 tag
* header_title_style: Specifies the H1 background, either 'light' or 'dark' (default is 'light')

## Open source acknowledgements

* http://jekyllrb.com
* https://github.com/aucor/jekyll-plugins
* https://github.com/jekyll/jekyll-sitemap
* https://github.com/mivok/markdownlint
* https://github.com/gjtorikian/html-proofer
