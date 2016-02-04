module Jekyll

  class LanguageSlideshowGenerator < Generator
    safe true

    def generate(site)
      python_cmd =  isset?(site.config['python_command']) ? 'python2' : site.config['python_command'];
      destination = site.config['destination']
      source = site.config['source']
      generate_script = File.join(source, '_plugins', 'language_slideshows', 'generate_script.py')

      puts ''
      puts 'Running the Slideshow Generator (Requires Python 2)'
      system "#{python_cmd} #{generate_script} -s #{source} -d #{destination}"
      puts 'Finished!'
      puts ''
    end

    private
      # Check if the parameter is set and not empty
      # param string param The param to check
      def isset?(param)
        return (param.nil? || param.empty?)
      end

  end
end
