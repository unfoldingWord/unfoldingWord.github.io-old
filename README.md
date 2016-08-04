master | [![Build Status](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io.svg?branch=master)](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io)

develop | [![Build Status](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io.svg?branch=develop)](https://travis-ci.org/unfoldingWord/unfoldingWord.github.io)

# unfoldingWord.org

Source for the unfoldingWord.org website.

## Developer Setup

### Installation

To setup a development environment for developing on this site, you need to run the following commands (after cloning this repo):

    cd unfoldingWord.github.io
    bundle install

If you do not have the `bundle` executable, then you'll need to run `sudo gem install bundle` first.


### Pre Production Testing

To test locally, run `make test`.  This will build the site and run Markdown lint and HTMLProofer.  If those pass then you can run `make serve` to have Jekyll serve the site so that you can browse your changes locally.

After testing locally, push your changes to master (you can use `make commit`).  They will then be visible at https://test.unfoldingword.org/ within seconds.


### Push to Production

After pre production testing, run `make publish` from this repo's root and
your changes should be visible within 5 minutes on
https://unfoldingword.org.  Note that running `make publish` will
immediately sync from the test site to production, without regenerating the
site first.

#### Updating dependencies

    bundle update

#### Custom YAML Values

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
