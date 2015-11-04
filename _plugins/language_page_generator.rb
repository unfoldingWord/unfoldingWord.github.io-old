require 'json'
require 'open-uri'

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
      self.data['title'] = 'unfoldingWord Resources: '+lang[:string]+' (' +lang[:code]+ ')'
      self.data['permalink'] = lang[:code]+'/index.html'
      self.data['lang_string'] = lang[:string]
      self.data['lang_code'] = lang[:code]
    end

  end

  class LanguagePageGenerator < Generator
    safe true

    def generate(site)
      template_path = File.join(site.source, '_templates', 'languages', 'view_page.md')

      completed_languages = get_completed_languages()
      if completed_languages.empty?
        puts 'Unable to grab the current available languages.'
        return
      end

      # Generate the pages
      # 
      completed_languages.each do |lang|
        site.pages << LanguagePage.new(template_path, 'index.md', site, site.source, lang[:code], lang)
      end
    end

    private
      # Get the completed languages from OBS API
      # 
      def get_completed_languages
        languages = []
        response = open('https://api.unfoldingword.org/obs/txt/1/obs-catalog.json').read
        data = JSON.parse(response)
        data.each do |lang|
          languages << {:code  =>  lang['language'], :string   =>  lang['string']}
        end
        return languages
      end
  end

end