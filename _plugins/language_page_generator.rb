require 'json'
require 'open-uri'
require 'i18n_data'

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
      self.data['title'] = 'unfoldingWord Resources: '+lang['string']+' (' +lang['code']+ ')'
      self.data['permalink'] = lang['code']+'/index.html'
      self.data['lang'] = lang
    end

  end

  class LanguagePageGenerator < Generator
    safe true

    def generate(site)
      template_path = File.join(site.source, '_templates', 'languages_page.md')
      languagesAPI = LanguagesAPI.new
      languages = languagesAPI.get_languages
      puts languages

      if languages.empty?
        puts 'Unable to grab the current available languages.'
        return
      end

      # Generate the pages
      # 
      languages.each do |lang|
        site.pages << LanguagePage.new(template_path, 'index.md', site, site.source, lang['code'], lang)
      end
    end
  end

  class LanguagesAPI
    # Initialize the class
    # 
    def initialize
      @languages = []
      set_languages()
    end

    # Get the languages
    # 
    def get_languages
      return @languages
    end

    private
      # Set the @languages param
      # 
      def set_languages
        response = open('https://api.unfoldingword.org/uw/txt/2/catalog.json').read
        data = JSON.parse(response)
        resources = {}
        data['cat'].each do |entry|
          resources[entry['slug']] = []
          entry['langs'].each do |lang|
            lang_data = {}
            code = lang['lc'][0,2]
            lang_data['code']       = code
            lang_data['string']     = language_to_string(code)
            @languages << lang_data unless languages_has_code(code)
            resources[entry['slug']] << code
          end
        end
        # Add resources to each language
        #
        @languages.each_with_index do |lang, i|
          @languages[i]['has_bible'] = resources['bible'].include?(lang['code'])
          @languages[i]['has_obs'] = resources['obs'].include?(lang['code'])
        end
      end

      # Check if the languages array has an object for the given language code
      # 
      def languages_has_code(code)
        @languages.any? {|h| h['code'] == code}
      end

      # Convert the language code to a string
      # 
      def language_to_string(code)
        begin
          i18n_data = I18nData.languages(code.upcase)
          i18n_data[code.upcase]
        rescue
          code.upcase
        end
      end

  end

end