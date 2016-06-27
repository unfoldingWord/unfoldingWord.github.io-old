# Builds the translation academy page from json

require 'open-uri'
require 'json'
require 'yaml'
require 'kramdown'

module Jekyll
  # noinspection RubyClassVariableUsageInspection
  class TaTag < Liquid::Tag

    @@toc_map = nil
    @@link_map = nil
    @@ta_objs = nil

    def initialize(tag_name, input, tokens)
      super
      @input = input
    end

    def render(context)
      @context = context

      # this forces print statements to immediately flush to the console
      $stdout.sync = true

      # because jekyll no longer renders tags marked blank
      @blank = false

      # be sure we have the toc mapping for all the manuals
      if @@toc_map == nil
        get_toc_map
      end

      ta_manual = @input.strip
      ta_md = []
      toc_text = "\n"

      print 'Getting the saved tA object for ' + ta_manual + '... '
      ta_obj = @@ta_objs[ta_manual]
      puts 'finished.'

      # get the meta data for this manual
      meta = ta_obj['meta']

      # get the TOC to use for ordering the articles
      toc_md = ta_obj['toc']
      toc_slugs = get_slugs(toc_md)
      toc_lines = toc_md.split(/\n/).reject(&:empty?)

      # each manual starts a new section in the html
      manual_md = '{::options auto_ids="false" /}' + "\n\n"

      # loop through the articles
      toc_slugs.each do |slug|
        article = ta_obj['articles'].find{|a| a['id'] == slug}
        print "Processing article #{meta['manual']}/#{article['title']}... "

        anchor_id = article['ref'].gsub(/\//, '_')
        manual_md << "## %s\n{: .sectionedit1 #%s}\n\n" % [article['title'], anchor_id]

        # insert the question
        if article['question'] && article['question'].length > 0
          manual_md << "*This page answers the question: #{article['question']}*\n\n"
        end

        # insert the dependent reading
        depend = article['depend']
        if depend && depend.length > 0
          manual_md << "*In order to understand this topic, it would be good to read:*\n\n"
          if depend.kind_of?(Array)
            depend.each do |d|
              manual_md << "* [[slug:#{d}]]\n"
            end
          else
            manual_md << "* [[slug:#{depend}]]\n"
          end
          manual_md << "\n"
        end

        # append the markdown for this article
        manual_md << article['text'] + "\n\n"

        # insert the recommended reading
        recommend = article['recommend']
        if recommend && recommend.length > 0
          manual_md << "*Next we recommend you learn about:*\n\n"
          if recommend.kind_of?(Array)
            recommend.each do |r|
              manual_md << "* [[slug:#{r}]]\n"
            end
          else
            manual_md << "* [[slug:#{recommend}]]\n"
          end
          manual_md << "\n"
        end

        # end the article with a hr
        manual_md << "\n-----\n\n"

        puts 'finished.'
      end

      # building the TOC
      print 'Building the TOC... '
      previous_indent = -1
      toc_lines.each_with_index do |toc_item, index|

        # the first item is always the manual name
        if index == 0
          next
        end

        slug = get_next_link(index, toc_lines)
        href = @@toc_map[slug][:href] || ''
        if href.empty?
          msg = 'ERROR: No href was found for TOC item "%s".'
          print_error_msg(msg)
        end

        current_indent = toc_item[/\A */].size

        # if index == 1
        #   toc_text << "- [%s](#%s)\n" % [toc_lines[0], href]
        # end

        # if the indent level changed, add a blank line so the parser is happy
        if previous_indent != current_indent
          toc_text << "\n"
          previous_indent = current_indent
        end

        # make sure the menu item starts with a hyphen so the sidebar menu script is happy
        trimmed = toc_item[current_indent..-1]
        if trimmed[0, 3] != '- ['
          toc_item = '%s- [%s]()' % [' ' * current_indent, trimmed.gsub(/^-\s/, '')]
        end

        search = toc_item.scan(/(\s*-\s\[.+\]\()([^\)]*)(\))/)  # /(\s*-\s\[[^\(]+\]\()([^\)]*)(\))/
        if href.empty?
          toc_text << "%s\n" % [toc_item]
        elsif search.empty?
          toc_text << (' ' * current_indent) + ("- [%s](#%s)\n" % [toc_item.gsub(/\s*^-\s/,''), href])
        else
          toc_text << "%s#%s%s\n" % [search[0][0], href, search[0][2]]
        end
      end
      toc_text << "\n"
      puts 'finished.'

      ta_md << manual_md

      # ================================================================================

      # # fix internal links
      # @@link_map.each do |pair|
      #   ta_text = ta_text.gsub('"' + pair[0] + '"', '"#' + pair[1] + '"')
      # end
      #
      # # make help@door43.org a hyperlink
      # ta_text = ta_text.gsub(/\s+help@door43\.org/i, ' <a href="mailto:help@door43.org">help@door43.org</a>')
      #
      # # fix door43 links
      # ta_text = ta_text.gsub(/href="\/en\/(.*?)"/i, 'href="https://door43.org/en/\1"')
      #
      # # fix img src attributes
      # ta_text = ta_text.gsub(/(<img\s+.*?src=")([^"?]+)(\??[^"]*?)(".*?\/>)/i) {
      #   # match $1 is the first part of the img tag, up to the src value
      #   # match $2 is the src value file name
      #   # match $3 will contain the src value querystring if one is present (which we don't need)
      #   # match $4 is the rest of the img tag
      #   fragments = "#{$2}".split('/')
      #   "#{$1}" + context.registers[:site].config['baseurl'] + '/assets/img/ta/' + fragments[-1] + "#{$4}"
      # }

      # end

      # convert body markdown to html
      print 'Converting markdown to HTML... '
      ta_text = ''
      ta_md.each do |section|
        s = replace_slugs(section, @@toc_map)
        s = clean_markdown(s)
        html = Kramdown::Document.new(s).to_html
        ta_text << '<div class="bs-docs-section">' + "\n" + html + "</div>\n"
      end
      puts 'finished.'

      # convert toc markdown to html
      print 'Converting TOC to HTML... '
      toc_html = Kramdown::Document.new(toc_text).to_html
      toc_html = toc_html.gsub(/<\/*p>/, '')  # remove <p> tags around each <li>
      toc_html = toc_html[5..-8]              # remove the outside <ul> tag
      puts 'finished.'

      # load the HTML template
      print 'Applying the ta_body.html template... '
      template = ''
      File.open(File.dirname(File.dirname(__FILE__)) + '/_includes/ta_body.html', 'r') do |f|
        template = f.read
      end

      # insert into the template
      template['{# Text #}'] = ta_text
      template['{# TOC #}'] = toc_html
      puts 'finished.'

      # return the completed template
      puts 'Finished building tA %s.' % [ta_manual]
      template
    end

    private

      # get the toc mappings for all manuals
      def get_toc_map

        $stdout.sync = true

        puts 'Getting all the slugs.'

        @@ta_objs = {}
        @@toc_map = {}
        @@link_map = []

        # load the json from the url
        ta_endpoint = @context.registers[:site].config['ta_endpoint']
        ta_manuals = %w(intro_1.json process_1.json translate_1.json translate_2.json checking_1.json checking_2.json audio_2.json gateway_3.json)
        ta_manuals.each do |ta_manual|

          json_file = File.join(ta_endpoint, ta_manual)
          ta_obj = nil

          print 'Loading the tA json file: ' + json_file + '... '
          open(json_file, 'r') do |f|
            ta_obj = JSON.parse(f.read)
          end
          puts 'finished.'

          # remember for later
          @@ta_objs[ta_manual] = ta_obj

          # get the meta data for this manual
          meta = ta_obj['meta']

          # get the TOC to use for ordering the articles
          toc_md = ta_obj['toc']
          toc_slugs = get_slugs(toc_md)

          # loop through the articles
          toc_slugs.each do |slug|
            article = ta_obj['articles'].find{|a| a['id'] == slug}
            print "Getting href for article #{meta['manual']}/#{article['title']}... "

            # append an anchor for the article
            anchor_id = article['ref'].gsub(/\//, '_')
            @@link_map.push([article['ref'], slug])
            if @@toc_map.key?(slug)
              msg = 'Error: Duplicate slug found (%s).'
              print_error_msg(msg)
            else
              @@toc_map[slug] = {:href => anchor_id, :title => article['title']}
            end

            puts 'finished.'
          end
        end

        puts 'Finished getting all the slugs.'
      end

      # Get the slugs from the toc markdown
      def get_slugs(toc_md)
        slug_arrays = toc_md.scan(/\[[^\(]*\]\(([^\[]*?)\)/m)
        slugs = []
        slug_arrays.each do |slug_array|
          slugs.push(slug_array[0])
        end

        slugs
      end

      # Find the appropriate link to use
      def get_next_link(index, toc_lines)

        max_index = toc_lines.length - 1
        (index..max_index).each do |i|
          search = toc_lines[i].scan(/\[[^\(]*\]\(([^\[]*?)\)/m)
          unless search.empty?
            return search[0][0]
          end
        end

        # if you get here no match was found
        ''
      end

      # replace slugs with links
      def replace_slugs(markdown, toc_map)
        markdown.gsub(/(\[\[slug:)([^\]]+)(\]\])/) {
          if toc_map.key?($2)
            itm = toc_map[$2]
            val = '<a href="#%s">%s</a>' % [itm[:href], itm[:title]]
          else
            val = "#{$1}#{$2}#{$3}"
            msg = "ERROR: Not able to find slug \"#{$2}\" in TOC."
            print_error_msg(msg)
          end
          val
        }
      end

      # clean up article markdown
      def clean_markdown(md)
        lines = md.split("\n")
        cleaned = []
        last_stripped = ''

        lines.each do |itm|
          stripped = itm.strip

          # make sure there is a blank line before the first line of a UL
          if stripped.start_with?('* ')
            if last_stripped != "\n" && !last_stripped.start_with?('* ')
              cleaned << ''
            end
          end

          cleaned << itm
          last_stripped = stripped
        end

        cleaned.join("\n")
      end

      def print_error_msg(msg)
        puts "\e[31m#{msg}\e[0m"
      end
  end
end

Liquid::Template.register_tag('translationAcademy', Jekyll::TaTag)
