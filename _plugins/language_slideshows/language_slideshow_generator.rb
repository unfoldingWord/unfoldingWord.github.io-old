module Jekyll

  class LanguageSlideshowGenerator < Generator
    safe true

    def generate(site)
      generate_script = File.join(site.source, '_plugins', 'language_slideshows', 'generate_script.py')
      puts ''
      puts 'Running the Slideshow Generator (Requires Python 2)'
      puts '---------------------------------------------------'
      python_cmd =  Jekyll.configuration({})['python_command']
      if python_cmd.nil? || python_cmd.empty?
        python_cmd = 'python2'
      end
      output = `#{python_cmd} #{generate_script}`
      puts output
      puts 'Finished!'
    end

  end
end
