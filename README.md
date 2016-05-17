# unfoldingWord.org

Source for the unfoldingWord.org website.


#### Installation ####

To setup a development environment for developing on this site, you need to run the following commands (after cloning this repo):

    cd unfoldingWord.github.io
    bundle install

If you do not have the `bundle` executable, then you'll need to run `sudo gem install bundle` first.


#### Pre Production Testing ####

After testing locally, push your changes to master (you can use `make commit`).  They will then be visible at https://test.unfoldingword.org/ within seconds.


#### Push to Production ####

After pre production testing, run `make publish` from this repo's root and
your changes should be visible within 5 minutes on
https://unfoldingword.org.  Note that running `make publish` will
immediately sync from the test site to production, without regenerating the
site first.


#### Open source acknowledgements ####

  * http://jekyllrb.com
  * https://github.com/aucor/jekyll-plugins
  * https://github.com/jekyll/jekyll-sitemap


#### Custom YAML Values ####

  * header_image: Used as the src for an img tag
  * header_image_layout: Currently the only value supported is 'icon'
  * header_title: The text for the page H1 tag
  * header_title_style: Specifies the H1 background, either 'light' or 'dark' (default is 'light')

#### Updating dependencies ####

    bundle update
