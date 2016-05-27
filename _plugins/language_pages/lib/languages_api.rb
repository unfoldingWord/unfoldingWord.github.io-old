current_directory = File.dirname(__FILE__)
require File.join(current_directory, 'language.rb')
require File.join(current_directory, 'language_resources.rb')

class LanguagesAPI

  # Initialize the class
  #
  def initialize
    @languages = []
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
            lang = UwLanguage.new(lang_entry['lc'], lang_data)
            @languages.push(lang)
          else
            lang = @languages[index]
          end

          lang.add_resource(LanguageResources.new(entry['slug'], lang_entry))

          # add translation resources (tN, tW, tQ)
          unless lang.resources.key?('translation')

            # currently this is only for English
            if lang_entry['lc'] == 'en'
              lang.add_resource(LanguageResources.new('translation', lang_entry))
            end
          end
        end
      end
    end

    def get_language_data(code)
      index = @language_data.index {|h| h['lc'] == code }
      return (index.nil?) ? nil : @language_data[index]
    end

end
