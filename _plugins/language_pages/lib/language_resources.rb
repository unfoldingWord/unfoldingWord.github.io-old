# Include all files in the parsers directory
#
lib_directory_glob = File.join(File.dirname(__FILE__), 'parsers', '*.rb')
Dir.glob(lib_directory_glob).each do|f|
  require f
end

class LanguageResources
  attr_reader :slug, :data, :language

  def initialize(slug, language_data)
    @slug = slug
    @language = language_data['lc']
    klass_name = classify("#{slug}_resource_parser")
    if Object.const_defined?(klass_name)
      parser_klass = Object.const_get(klass_name)
      parser = parser_klass.new(language_data)
      @data = parser.parse
    else
      puts "#{klass_name} is not defined!"
      @data = []
    end
  end

  private
    def classify(str)
      str.split('_').collect!{ |w| w.capitalize }.join
    end
end
