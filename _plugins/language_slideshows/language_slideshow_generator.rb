module Jekyll

  class LanguageSlideshowGenerator < Generator
    safe true
    priority :lowest

    def generate(site)

      if site.config.key?('skip_obs') && site.config['skip_obs']
        puts 'Skipping OBS Slideshow Generator.'
        return
      end

      python_cmd =  isset?(site.config['python_command']) ? 'python2' : site.config['python_command']
      destination = site.config['destination']
      source = site.config['source']
      generate_script = File.join(Dir.pwd, '_plugins', 'language_slideshows', 'generate_script.py')

      puts ''
      puts 'Running the Slideshow Generator (Requires Python 2)'
      system "#{python_cmd} \"#{generate_script}\" -s \"#{source}\" -d \"#{destination}\""
      puts 'Finished!'
      puts ''
    end

    private
      # Check if the parameter is set and not empty
      # param string param The param to check
      def isset?(param)
        (param.nil? || param.empty?)
      end

  end
end
