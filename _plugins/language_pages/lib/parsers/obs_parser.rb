class ObsResourceParser

  def initialize(language_data)
    @data = language_data
    @low_res_slideshow_url  = '/%s/slides/360px/01/'
    @high_res_slideshow_url = '/%s/slides/2160px/01/'
    @pdf_url                = 'https://api.unfoldingword.org/obs/txt/1/%s/obs-%s-v%s.pdf'
    @low_res_audio_url      = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_32kbps.zip'
    @med_res_audio_url      = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_64kbps.zip'
    @high_res_audio_url     = 'https://api.unfoldingword.org/obs/mp3/1/%s/%s_obs_v%s_mp3_128kbps.zip'
    @low_res_video_url      = 'https://api.unfoldingword.org/obs/mp4/1/%s/%s_obs_v%s_mp4_360p.zip'
    @high_res_video_url     = 'https://api.unfoldingword.org/obs/mp4/1/%s/%s_obs_v%s_mp4_720p.zip'
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
    }
    if @data['lc'] == 'en'
      data['audio_urls'] = get_audio_urls(@data['lc'], version)
      data['video_urls'] = get_video_urls(@data['lc'], version)
      # Must be a cleaner way to do this
      story_parser = ObsStoryParser.new(@data['vers'][0]['toc'][0]['media']['audio']['src_list'])
      data['stories'] = story_parser.parse
    end
    resources << data
    resources
  end

  private
    # Get the audio urls
    #
    def get_audio_urls(code, version)
      audio_urls = {
        'low'   =>  @low_res_audio_url % [code, code, version],
        'med'   =>  @med_res_audio_url % [code, code, version],
        'high'  =>  @high_res_audio_url % [code, code, version]
      }
    end

    # Get the video urls
    #
    def get_video_urls(code, version)
      video_urls = {
        'low'   =>  @low_res_video_url % [code, code, version],
        'high'  =>  @high_res_video_url % [code, code, version]
      }
    end
end

class ObsStoryParser

  def initialize(story_data)
    @data = story_data
  end

  def parse
    stories = []
    @data.each do |story|
      stories << {
        'title_id'    =>  "CH_#{story['chap']}",
        'chapter'     =>  story['chap'].to_i.to_s,
        'audio_urls'  =>  {
          'low'   =>  story['src'].gsub('{bitrate}', '32'),
          'high'  =>  story['src'].gsub('{bitrate}', '64'),
        }
      }
    end
    return stories
  end

end
