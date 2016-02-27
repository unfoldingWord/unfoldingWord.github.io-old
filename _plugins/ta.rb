# Builds the translation academy page from json

require 'open-uri'
require 'json'

module Jekyll
  class TaTag < Liquid::Block

    def render(context)

      # class instance variables
      @context = context
      @link_map = []
      @chapter_div = ''
      @toc_li = ''

      # load the json from the url
      ta_obj = {}
      json_file = File.join(context.registers[:site].config['source'], '_plugins', 'ta-en.json')
      # json_file = context.registers[:site].config['ta_endpoint']
      puts 'Loading the tA json file: ' + json_file
      open(json_file, 'r') do |f|
        ta_obj = JSON.parse(f.read)
      end

      ta_text = ''
      toc_text = ''

      ta_obj['chapters'].each do |chapter|
        #ta_text << chapter['title'] + "<br>\n"

        puts 'Processing chapter ' + chapter['title']

        # each chapter starts a new section in the html
        @chapter_div = '<div class="bs-docs-section">' + "\n"
        @toc_li = ''

        # process all the frames and sections in this chapter
        process_block(chapter, true)

        # close this section div
        @chapter_div << "</div>\n"

        ta_text << @chapter_div
        toc_text << @toc_li
      end

      # fix internal links
      @link_map.each do |pair|
        ta_text = ta_text.gsub('"' + pair[0] + '"', '"#' + pair[1] + '"')
      end

      # # fix titles
      # ta_text = ta_text.gsub(/title=".*:.*"/, '')

      # make help@door43.org a hyperlink
      ta_text = ta_text.gsub(/\s+help@door43\.org/i, ' <a href="mailto:help@door43.org">help@door43.org</a>')

      # fix door43 links
      ta_text = ta_text.gsub(/href="\/en\/(.*?)"/i, 'href="https://door43.org/en/\1"')

      # fix img src attributes
      ta_text = ta_text.gsub(/(<img\s+.*?src=")([^"?]+)(\??[^"]*?)(".*?\/>)/i) {
        # match $1 is the first part of the img tag, up to the src value
        # match $2 is the src value file name
        # match $3 will contain the src value querystring if one is present (which we don't need)
        # match $4 is the rest of the img tag
        fragments = "#{$2}".split('/')
        "#{$1}" + context.registers[:site].config['baseurl'] + '/assets/img/ta/' + fragments[-1] + "#{$4}"
      }

      # load the html template
      template = ''
      File.open(File.dirname(File.dirname(__FILE__)) + '/_includes/ta_body.html', 'r') do |f|
        template = f.read
      end

      # insert into the template
      template['{# Text #}'] = ta_text
      template['{# TOC #}'] = toc_text

      # return the completed template
      puts 'Finished building tA.'
      template
    end

    private

      # Process all the frames and sections in this block.
      def process_block(block, is_section)

        # table of contents
        if block.has_key?('frames') or block.has_key?('sections')

          # section heading
          if is_section
            @toc_li << get_first_link(block)
          end

          @toc_li << '<ul>' + "\n"
        end

        # loop through frames
        if block.has_key?('frames')

          block['frames'].each do |frame|

            # skip the report-a-problem form
            next if frame['id'] == 'report-a-problem'

            @chapter_div << frame['text'] + "\n\n\n"
            @toc_li << '<li><a href="#' + frame['id'] + '">' + frame['title'] + "</a>\n"
            @link_map.push([frame['ref'], frame['id']])

            # check for sections and frames inside this frame
            process_block(frame, false)

            @toc_li << "</li>\n"
          end
        end

        # loop through sections
        if block.has_key?('sections')

          block['sections'].each do |section|

            # process frames and sections inside this section
            process_block(section, true)
          end
        end

        #close this section of the TOC
        if block.has_key?('frames') or block.has_key?('sections')
          @toc_li << "</ul>\n"

          if is_section
            @toc_li << "</li>\n"
          end
        end
      end

      # Find an appropriate link to use for the section header.
      def get_first_link(block)

        if block.has_key?('frames')
          return_val = '<li><a href="#' + block['frames'][0]['id'] + '">' + block['title'] + '</a>' + "\n"

        elsif block.has_key?('sections') && block['sections'][0].has_key?('frames')
          return_val = '<li><a href="#' + block['sections'][0]['frames'][0]['id'] + '">' + block['title'] + '</a>' + "\n"

        else
          return_val = '<li><a href="#">' + block['title'] + '</a>' + "\n"

        end

        return_val
      end
  end
end

Liquid::Template.register_tag('translationAcademy', Jekyll::TaTag)
