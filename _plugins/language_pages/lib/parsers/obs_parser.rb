class ObsResourceParser

  def initialize(language_data)
    @data = language_data
    @low_res_slideshow_url  = '/%s/slides/360px/01/'
    @high_res_slideshow_url = '/%s/slides/2160px/01/'
    @pdf_url                = 'https://api.unfoldingword.org/obs/txt/1/%s/obs-%s-v%s.pdf'
    @low_res_audio_url      = 'https://cdn.door43.org/%s/obs/v%s/32kbps/%s_obs_32kbps.zip'
    @med_res_audio_url      = 'https://cdn.door43.org/%s/obs/v%s/64kbps/%s_obs_64kbps.zip'
    @high_res_audio_url     = 'https://cdn.door43.org/%s/obs/v%s/128kbps/%s_obs_128kbps.zip'
    @low_res_video_url      = 'https://cdn.door43.org/%s/obs/v%s/360p/%s_obs_360p.zip'
    @high_res_video_url     = 'https://cdn.door43.org/%s/obs/v%s/720p/%s_obs_720p.zip'
    @checking_image_url     = '/assets/img/uW-Level%s-64px.png'
  end

  def parse
    resources = []
    status = @data['vers'][0]['status']
    version = status['version'].gsub('.','_')
    data = {
      'audio_urls'              =>  {},
      'video_urls'              =>  {},
      'stories'                 =>  [],
      'low_res_slideshow_url'   =>  @low_res_slideshow_url % [@data['lc']],
      'high_res_slideshow_url'  =>  @high_res_slideshow_url % [@data['lc']],
      'pdf_url'                 =>  @pdf_url % [@data['lc'], @data['lc'], version],
      'checking_level'          =>  status['checking_level'],
      'checking_level_image'    =>  @checking_image_url % [status['checking_level']],
      'published_on'            =>  get_published_date(status['publish_date'])
    }
    if @data['lc'] == 'en'
      data['audio_urls'] = get_audio_urls(@data['lc'], version)
      data['video_urls'] = get_video_urls(@data['lc'], version)
      # Must be a cleaner way to do this
      story_parser = ObsStoryParser.new(@data['vers'][0]['toc'][0]['media']['audio']['src_list'])
      data['stories'] = story_parser.parse(@data['lc'], version)
    end
    resources << data
    resources
  end

  private
    # Get the audio urls
    #
    def get_audio_urls(code, version)
      audio_urls = {
        'low'   =>  @low_res_audio_url % [code, version, code],
        'med'   =>  @med_res_audio_url % [code, version, code],
        'high'  =>  @high_res_audio_url % [code, version, code]
      }
    end

    # Get the video urls
    #
    def get_video_urls(code, version)
      video_urls = {
        'low'   =>  @low_res_video_url % [code, version, code],
        'high'  =>  @high_res_video_url % [code, version, code]
      }
    end

    # Get the published on date
    #
    # published_on - String representing the date it was published (20151120)
    #
    def get_published_date(published_on)
      published_on.gsub!('-', '')
      return '' if published_on.nil? || published_on.empty? || published_on.length > 8
      year = published_on[0,4].to_i
      month = published_on[4,2].to_i
      day = published_on[6,2].to_i
      DateTime.new(year, month, day)
    end
end

class ObsStoryParser

  def initialize(story_data)
    @data = story_data
    @low_res_video_url      = 'https://cdn.door43.org/%s/obs/v%s/360p/%s_obs_%s_360p.mp4'
    @high_res_video_url     = 'https://cdn.door43.org/%s/obs/v%s/720p/%s_obs_%s_720p.mp4'
  end

  def parse(language, version)
    stories = []
    @data.each do |story|
      stories << {
        'title_id'    =>  "CH_#{story['chap']}",
        'chapter'     =>  story['chap'].to_i.to_s,
        'audio_urls'  =>  {
          'low'   =>  story['src'].gsub('{bitrate}', '32'),
          'high'  =>  story['src'].gsub('{bitrate}', '64'),
        },
        'video_urls'  =>  {
          'low'   =>  @low_res_video_url  % [language, version, language, story['chap']],
          'high'  =>  @high_res_video_url  % [language, version, language, story['chap']],
        }
      }
    end
    stories.sort_by{ |v| v['chapter'].to_i }
  end

end
