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
      self.data['title'] = 'unfoldingWord Resources: '+lang['string']+' (' +lang['code']+ ')'
      self.data['permalink'] = lang['code']+'/index.html'
      self.data['lang'] = lang
    end

  end

  class LanguagePageGenerator < Generator
    safe true

    def generate(site)
      template_path = File.join(site.source, '_layouts', 'languages_page.md')
      languagesAPI = LanguagesAPI.new
      languages = languagesAPI.get_languages

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
      @low_res_slideshow_url  = 'https://api.unfoldingword.org/obs/txt/1/%s/slides/360px/01/'
      @high_res_slideshow_url = 'https://api.unfoldingword.org/obs/txt/1/%s/slides/2160px/01/'
      @pdf_url                = 'https://api.unfoldingword.org/obs/txt/1/%s/obs-%s-v%s.pdf'
      @low_res_audio_url      = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_32kbps.zip'
      @med_res_audio_url      = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_64kbps.zip'
      @high_res_audio_url     = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_128kbps.zip'
      @low_res_video_url      = 'https://api.unfoldingword.org/obs/mp4/1/%s/%s_obs_v%s_mp4_360p.zip'
      @high_res_video_url     = 'https://api.unfoldingword.org/obs/mp4/1/%s/%s_obs_v%s_mp4_720p.zip'
      @checking_image_url     = '/assets/img/uW-Level%s-64px.png'
      set_language_data()
      set_languages()
    end

    # Get the languages
    # 
    def get_languages
      return @languages
    end

    private

      # Get the language data so we can set the direction and text version of it
      #
      def set_language_data
        response = open('http://td.unfoldingword.org/exports/langnames.json').read
        @language_data = JSON.parse(response)
      end

      # Set the @languages param
      # 
      def set_languages
        response = open('https://api.unfoldingword.org/uw/txt/2/catalog.json').read
        data = JSON.parse(response)
        data['cat'].each do |entry|
          entry['langs'].each do |lang|
            lang_data = {'code' =>  lang['lc'], 'string'  =>  language_to_string(lang['lc']), 'direction' =>  language_direction(lang['lc'])}
            # We fill this in later
            # 
            lang_data['resources']  = {'obs'   =>  nil, 'bible' =>  nil}
            @languages << lang_data unless languages_has_code(lang['lc'])
            add_resource_to_language(entry['slug'], lang)
          end
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
        index = @language_data.index {|h| h['lc'] == code }
        return (index) ? @language_data[index]['ln'] : code
      end

      # Get the language direction
      # 
      def language_direction(code)
        index = @language_data.index {|h| h['lc'] == code }
        return (index) ? @language_data[index]['ld'] : 'ltr'
      end

      # Collect all the resources for a language
      #
      def add_resource_to_language(slug, lang)
        code = lang['lc']
        index = @languages.index {|h| h['code'] == code }
        status = lang['vers'][0]['status']
        version = status['version'].gsub('.','_')
        # ASSUMPTION: There is only 1 version in the vers array?
        # 
        if slug == 'obs'
          # Hack until they add these resources to the feed
          # 
          data = {
            'audio_urls'              =>  {
              'low'   =>  (code == 'en') ? @low_res_audio_url % [code, code, version] : '',
              'med'   =>  (code == 'en') ? @med_res_audio_url % [code, code, version] : '',
              'high'  =>  (code == 'en') ? @high_res_audio_url % [code, code, version] : ''
            },
            'video_urls'              => {
              'low'   =>  (code == 'en') ? @low_res_video_url % [code, code, version] : '',
              'high'  =>  (code == 'en') ? @high_res_video_url % [code, code, version] : ''
            },
            'low_res_slideshow_url'   =>  @low_res_slideshow_url % [code],
            'high_res_slideshow_url'  =>  @high_res_slideshow_url % [code],
            'pdf_url'                 =>  @pdf_url % [code, code, version],
            'checking_level'          =>  status['checking_level'],
            'checking_level_image'    =>  @checking_image_url % [status['checking_level']]
          }
        elsif slug == 'bible'
          data = []
          lang['vers'].each do |bible|
            data << {
              'name'                  =>  bible['name'],
              'slug'                  =>  bible['slug'],
              'checking_level'        =>  bible['status']['checking_level'],
              'checking_level_image'  =>  @checking_image_url % [bible['status']['checking_level']]
            }
          end
        end
        @languages[index]['resources'][slug] = data unless index.nil?
      end

  end

end