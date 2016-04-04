current_directory = File.dirname(__FILE__)
require File.join(current_directory, 'language.rb')
require File.join(current_directory, 'language_resources.rb')

class LanguagesAPI

  # Initialize the class
  #
  def initialize
    @languages = []
    @low_res_slideshow_url  = '/%s/slides/360px/01/'
    @high_res_slideshow_url = '/%s/slides/2160px/01/'
    @pdf_url                = 'https://api.unfoldingword.org/obs/txt/1/%s/obs-%s-v%s.pdf'
    @low_res_audio_url      = 'https://cdn.unfoldingword.org/%s/obs/v4/32kbps/%s_obs_32kbps.zip'
    @med_res_audio_url      = 'https://cdn.unfoldingword.org/%s/obs/v4/64kbps/%s_obs_64kbps.zip'
    @high_res_audio_url     = 'https://cdn.unfoldingword.org/%s/obs/v4/128kbps/%s_obs_128kbps.zip'
    @low_res_video_url      = 'https://cdn.unfoldingword.org/%s/obs/v4/360p/%s_obs_360p.zip'
    @high_res_video_url     = 'https://cdn.unfoldingword.org/%s/obs/v4/720p/%s_obs_720p.zip'
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
        entry['langs'].each do |lang_entry|
          index = @languages.index {|h| h.code == lang_entry['lc'] }
          if index.nil?
            lang_data = get_language_data(lang_entry['lc'])
            lang = Language.new(lang_entry['lc'], lang_data)
            lang.add_resource(LanguageResources.new(entry['slug'], lang_entry))
            @languages.push(lang)
          else
            @languages[index].add_resource(LanguageResources.new(entry['slug'], lang_entry))
          end
        end
      end
    end

    def get_language_data(code)
      index = @language_data.index {|h| h['lc'] == code }
      return (index.nil?) ? nil : @language_data[index]
    end

end
