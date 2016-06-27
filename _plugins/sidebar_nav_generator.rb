# This generator builds the sidebar nav based on the headers in the Markdown file.
# H2 is set to the top navigation link, and sibling h3 tags are sub navigation links.
# To use,  Add the following meta tag to the markdown file:
# generate_sidebar_nav: true
# You can then access the new nav using the page.sidebar_nav variable.
#
# Inspired by http://blog.honeybadger.io/automatically-generating-subnavigation-from-headings-in-jekyll/
#
require 'nokogiri'

module Jekyll

  class SidebarNavGenerator < Generator
    safe true

    def generate(site)
      parser = Jekyll::Converters::Markdown.new(site.config)

      site.pages.each do |page|
        if page['generate_sidebar_nav'] && page.ext == '.md'
          puts "Generating Sidebar Nav for #{page['title']}"
          doc = Nokogiri::HTML(parser.convert(page['content']))
          sidebar = []
          doc.css('h2').each do |heading|
            sidebar << {
              'title'   =>  heading.text,
              'url'     =>  "##{heading['id']}",
              'sub_nav' =>  retrieve_sub_nav(heading.next_element, [])
            }
          end
          page.data['sidebar_nav'] = sidebar
        end
      end
    end

    private
      # Recursive method for retrieving the sub navigation.
      #
      def retrieve_sub_nav(sibling, sub_nav)
        if sibling.nil? || sibling.name == 'h2'
          # nil? = End of the page.
          # h2 = Next section
          #
          return sub_nav
        elsif sibling.name == 'h3'
          # Capture the sub heading
          #
          sub_nav << {
            'title'   =>  sibling.text,
            'url'     =>  "##{sibling['id']}"
          }
          return retrieve_sub_nav(sibling.next_element, sub_nav)
        else
          # Any other tags should continue
          #
          return retrieve_sub_nav(sibling.next_element, sub_nav)
        end
      end
  end

end
