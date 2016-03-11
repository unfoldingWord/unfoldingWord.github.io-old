class BibleResourceParser

  def initialize(language_data)
    @data = language_data
    @checking_image_url = '/assets/img/uW-Level%s-64px.png'
  end

  def parse
    resources = []
    @data['vers'].each do |bible|
      resources << {
        'name'                  =>  bible['name'],
        'slug'                  =>  bible['slug'],
        'checking_level'        =>  bible['status']['checking_level'],
        'checking_level_image'  =>  @checking_image_url % [bible['status']['checking_level']]
      }
    end
    resources
  end

end
