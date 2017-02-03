require 'json'
require 'open-uri'

require File.join(File.dirname(__FILE__), 'lib', 'languages_api.rb')

module Jekyll

  class LanguagePage < Page
    # Initializes a new Language Page.
    #
    #  +template_path+ is the path to the layout template to use.
    #  +name+          is the name of the final file created.  Add md extension to process markdown
    #  +site+          is the Jekyll Site instance.
    #  +base+          is the String path to the <source>.
    #  +lang_dir+      is the String path between _site and the language folder.
    #  +lang+          is the current language data.
    def initialize(template_path, name, site, base, lang_dir, lang)
      @site = site
      @base = base
      @dir = lang_dir
      @name = name

      self.process(name)
      template_dir    = File.dirname(template_path)
      template        = File.basename(template_path)
      # Read the YAML data from the layout page.
      self.read_yaml(template_dir, template)
      self.data['title'] = "unfoldingWord Resources: #{lang.text} (#{lang.code})"
      self.data['permalink'] = "#{lang.code}/index.html"
      self.data['lang'] = lang
    end

  end

  class LanguagePageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      template_path = File.join(site.source, '_layouts', 'languages_page.md')
      languagesAPI = LanguagesAPI.new
      languages = languagesAPI.get_languages

      puts ''
      puts 'Running the language page generator...'
      if languages.empty?
        puts 'Unable to grab the current available languages.'
        return
      end

      # Generate the pages
      #
      languages.each do |lang|
        site.pages << LanguagePage.new(template_path, 'index.md', site, site.source, lang.code, lang)
      end
    end
  end

end
