# Builds the translation academy page from json

require 'open-uri'
require 'json'

module Jekyll
  class TaTag < Liquid::Block

    def render(context)

      @context = context

      # load the json from the url
      ta_obj = {}
      open(context.registers[:site].config['ta_endpoint'], 'r') do |f|
        ta_obj = JSON.parse(f.read)
      end

      ta_text = ''
      toc_text = ''
      link_map = []

      ta_obj['chapters'].each do |chapter|
        #ta_text << chapter['title'] + "<br>\n"

        # each chapter starts a new section
        chapter_div = '<div class="bs-docs-section">' + "\n"

        # table of contents
        toc_li = '<li><a href="#' + chapter['frames'][0]['id'] + '">' + chapter['title'] + '</a>' + "\n"
        toc_li << '<ul class="nav">' + "\n"

        # add the frame text
        chapter['frames'].each do |frame|
          chapter_div << frame['text'] + "\n\n\n"
          toc_li << '<li><a href="#' + frame['id'] + '">' + frame['title'] + '</a></li>' + "\n"
          link_map.push([frame['ref'], frame['id']])
        end

        # close this section div
        chapter_div << "</div>\n"

        #close this section of the TOC
        toc_li << "</ul>\n</li>\n"

        ta_text << chapter_div
        toc_text << toc_li
      end

      # fix internal links
      link_map.each do |pair|
        ta_text = ta_text.gsub('"' + pair[0] + '"', '"#' + pair[1] + '"')
      end

      # fix titles
      ta_text = ta_text.gsub(/title=".*:.*"/, '')

      # load the html template
      template = ''
      File.open(File.dirname(File.dirname(__FILE__)) + '/_includes/ta_body.html', 'r') do |f|
        template = f.read
      end

      # insert into the template
      template['{# Text #}'] = ta_text
      template['{# TOC #}'] = toc_text

      # return the completed template
      template
    end

  end
end

Liquid::Template.register_tag('translationAcademy', Jekyll::TaTag)
