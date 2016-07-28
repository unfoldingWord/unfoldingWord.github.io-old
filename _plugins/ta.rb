# Builds the translation academy page from json

require 'open-uri'
require 'json'
require 'yaml'
require 'kramdown'
require 'uri'

module Jekyll
  # noinspection RubyClassVariableUsageInspection
  class TaTag < Liquid::Tag

    @@toc_map = nil
    @@link_map = nil
    @@ta_objs = nil
    @@dokuwiki_links = {}

    def initialize(tag_name, input, tokens)
      super
      @input = input
    end

    def render(context)
      @context = context
      @base_url = @context.registers[:site].config['baseurl']

      # this forces print statements to immediately flush to the console
      $stdout.sync = true

      # because jekyll no longer renders tags marked blank
      @blank = false

      # be sure we have the toc mapping for all the manuals
      if @@toc_map == nil
        get_toc_map
      end

      ta_manual = @input.strip
      toc_text = "\n"

      print_ok_msg('Getting the saved tA object for ' + ta_manual + '... ')
      ta_obj = @@ta_objs[ta_manual]
      puts 'finished.'

      # get the meta data for this manual
      meta = ta_obj['meta']

      # get the TOC to use for ordering the articles
      toc_md = ta_obj['toc']
      toc_slugs = get_slugs(toc_md)
      toc_lines = toc_md.split(/\n/).reject(&:empty?)

      # tell kramdown to not auto-generate ids for elements
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

      # set up links to files in same repository
      manual_md = fix_links_to_self(manual_md)

      # set up links to other tA repositories
      manual_md = fix_links_to_other_ta_pages(manual_md)

      # set up other links in the text of the article
      manual_md = fix_links_in_text(manual_md)

       # convert body markdown to html
      print 'Converting markdown to HTML... '
      manual_md = replace_slugs(manual_md, @@toc_map)
      manual_md = get_dokuwiki_links(manual_md)
      manual_md = clean_markdown(manual_md)
      ta_html = Kramdown::Document.new(manual_md).to_html

      # remove <p> tags around each <li>
      ta_html = ta_html.gsub(/(<li>)(\s*<p>)(.*?)(<\/p>)/) {"#{$1}#{$3}"}

      # each manual starts a new section in the html
      ta_html = '<div class="bs-docs-section">' + "\n" + ta_html + "</div>\n"
      puts 'finished.'

      # convert toc markdown to html
      print 'Converting TOC to HTML... '
      toc_html = Kramdown::Document.new(toc_text).to_html

      # remove <p> tags around each <li>
      toc_html = toc_html.gsub(/(<li>)(\s*<p>)(.*?)(<\/p>)/) {"#{$1}#{$3}"}

      # remove the outside <ul> tag
      toc_html = toc_html[5..-8]
      puts 'finished.'

      # load the HTML template
      print 'Applying the ta_body.html template... '
      template = ''
      File.open(File.dirname(File.dirname(__FILE__)) + '/_includes/ta_body.html', 'r') do |f|
        template = f.read
      end

      # insert into the template
      template['{# File #}'] = get_file_name(ta_manual, meta['status']['version'])
      template['{# Text #}'] = ta_html
      template['{# TOC #}'] = toc_html
      puts 'finished.'

      # return the completed template
      print_ok_msg('Finished building tA %s.' % [ta_manual])
      puts ''
      template
    end

    private

    # get the name for the PDF link
    def get_file_name(manual, version)

      fn = ''

      case manual
        when 'audio_2.json'
          fn = 'audio'
        when 'checking_1.json'
          fn = 'checking-vol1'
        when 'checking_2.json'
          fn = 'checking-vol2'
        when 'translate_1.json'
          fn = 'translate-vol1'
        when 'translate_2.json'
          fn = 'translate-vol2'
        when 'gateway_3.json'
          fn = 'gl'
        when 'intro_1.json'
          fn = 'intro'
        when 'process_1.json'
          fn = 'process'
        else
          'en-ta-v%s' % [version]
      end

      '%sen-ta-%s-v%s.pdf' % [@context.registers[:site].config['ta_pdf_cdn'], fn, version]
    end

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
      puts ''
    end

    # Get the slugs from the toc markdown
    def get_slugs(toc_md)
      slug_arrays = toc_md.scan(/\[.*?\]\(([^\[]*?)\)/m)
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
      markdown.gsub(/(\[\[slug:)(.+?)(\]\])/) {
        if $2.start_with?('en:')
          val = "[[#{$2}]]"
        elsif toc_map.key?($2)
          itm = toc_map[$2]
          href = get_page_from_anchor(itm[:href])
          val = '<a href="%s">%s</a>' % [href, itm[:title]]
        else
          val = "#{$1}#{$2}#{$3}"
          msg = "ERROR: Not able to find slug \"#{$2}\" in TOC."
          print_error_msg(msg)
        end
        val
      }
    end

    # prepend the correct page to the anchor
    def get_page_from_anchor(anchor)
      parts = anchor.downcase.split('_')
      if parts.count < 3
        msg = "ERROR: Anchor \"%s\" must have at least 3 segments." % [anchor]
        print_error_msg(msg)
        return anchor
      end

      vol = parts[0][-1]

      page = case parts[1] + vol
               when 'intro1'
                 '/academy/ta-intro.html'
               when 'process1'
                 '/academy/ta-process.html'
               when 'translate1'
                 '/academy/ta-translation-1.html'
               when 'translate2'
                 '/academy/ta-translation-2.html'
               when 'checking1'
                 '/academy/ta-checking-1.html'
               when 'checking2'
                 '/academy/ta-checking-2.html'
               when 'audio2'
                 '/academy/ta-audio.html'
               when 'gateway3'
                 '/academy/ta-gateway-language.html'
               else
                 msg = "ERROR: Page not found for \"%s\"." % [anchor]
                 print_error_msg(msg)
                 ''
             end

      page + '#' + anchor
    end

    # clean up article markdown
    def clean_markdown(md)
      lines = md.split("\n")
      cleaned = []
      last_stripped = ''

      lines.each do |itm|
        stripped = itm.strip

        if stripped.start_with?('* ')
          # make sure there is a blank line before the first line of a UL
          if last_stripped != "\n" && !last_stripped.start_with?('* ')
            cleaned << ''
          end

        elsif stripped.start_with?('1. ')
          # make sure there is a blank line before the first line of a OL
          if last_stripped != "\n" && !last_stripped.start_with?('1. ')
            cleaned << ''
          end

        elsif stripped.start_with?('>')
          # make sure there is a blank line before the first line of a block quote
          if last_stripped != "\n" && !last_stripped.start_with?('>')
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

    def print_ok_msg(msg)
      puts "\e[34m#{msg}\e[0m"
    end

    def get_dokuwiki_links(markdown)

      # look for links formatted like this [:en:obe:kt:godthefather](:en:obe:kt:godthefather)
      md = markdown.gsub(/(\[:?)(en:.*?)(\])(\(:?)(en:.*?)(\))/) {
        fetch_dokuwiki_link($2)
      }

      # look for links formatted like this [[:en:obe:other:winnow]]
      md.gsub(/(\[\[:?)(en:.*?)(\]\])/) {
        fetch_dokuwiki_link($2)
      }
    end

    # get markdown link for the dokuwiki link
    def fetch_dokuwiki_link(dw_link)
      dw_link = dw_link.split('|')[0]
      unless @@dokuwiki_links.key?(dw_link)
        print 'Getting dokuwiki link %s... ' % [dw_link]
        href = 'https://door43.org/%s' % [dw_link.gsub(/:/, '/')]
        dw_page = ''
        open(href, 'r') do |f|
          dw_page = f.read
        end
        matches = dw_page.scan(/<title>(.*?)<\/title>/)
        page_title = matches[0][0].gsub(/\s\[Door43\]$/, '')  # remove [Door43] from the end of the title
        @@dokuwiki_links[dw_link] = '[%s](%s)' % [page_title, href]
        puts 'finished.'
      end

      @@dokuwiki_links[dw_link]
    end

    # set up links to articles in the same repository
    def fix_links_to_self(markdown)

      # they will be formatted like this, with no slashes in the URL [Article Title](file-name.md)
      markdown.gsub(/\[.*?\]\(([^\/]*?).md\)/) {
        "[[slug:#{$1}]]"
      }
    end

    # set up links to articles in other tA repositories
    def fix_links_to_other_ta_pages(markdown)

      # they will have href like https://git.door43.org/Door43/en-ta-intro/src/master/content/ta_intro.md
      markdown.gsub(/\[(.*?)\]\(.*?git.door43.org\/Door43\/(en-ta-[^\/]+?)\/.*?([^\/]+?).md\)/) {
        href = case $2
                 when 'en-ta-intro'
                   '/academy/ta-intro.html'
                 when 'en-ta-process'
                   '/academy/ta-process.html'
                 when 'en-ta-translate-vol1'
                   '/academy/ta-translation-1.html'
                 when 'en-ta-translate-vol2'
                   '/academy/ta-translation-2.html'
                 when 'en-ta-checking-vol1'
                   '/academy/ta-checking-1.html'
                 when 'en-ta-checking-vol2'
                   '/academy/ta-checking-2.html'
                 when 'en-ta-audio'
                   '/academy/ta-audio.html'
                 when 'en-ta-gl'
                   '/academy/ta-gateway-language.html'
                 else
                   ''
               end

        if @@toc_map.key?($3)
          itm = @@toc_map[$3]
          href << '#' + itm[:href]
        else
          msg = "ERROR: Not able to find slug \"#{$3}\" in TOC."
          print_error_msg(msg)
        end

        href = @base_url + href

        "[#{$1}](#{href})"
      }
    end

    # set up links that are simply a URL in the body of the article
    def fix_links_in_text(markdown)
      markdown.gsub(/(\s)(https?:\/\/[^\s]*?)([\.\)][\s\)\.])/) {
        "#{$1}[#{$2}](#{$2})#{$3}"
      }
    end
  end
end

Liquid::Template.register_tag('translationAcademy', Jekyll::TaTag)
