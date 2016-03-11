class Language
  attr_reader :code, :text, :direction, :resources

  def initialize(_code_, _data_)
    @code = _code_
    @data = _data_
    @text = (@data.nil?) ? @code : @data['ln']
    @direction = (@data.nil?) ? 'ltr' : @data['ld']
    @resources = {}
  end

  # Add the resource to the resources array
  # param LanguageResource resource The resource object
  #
  def add_resource(resource)
    @resources[resource.slug] = resource.data
  end

  # Make these attributes accessible to Liquid
  #
  def to_liquid
    {
      'code'      =>  code,
      'text'      =>  text,
      'direction' =>  direction,
      'resources' =>  resources
    }
  end
end
