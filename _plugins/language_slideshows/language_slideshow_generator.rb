module Jekyll

  class LanguageSlideshowGenerator < Generator
    safe true

    def generate(site)
      generate_script = File.join(site.source, '_plugins', 'language_slideshows', 'generate_script.py')
      puts ''
      puts 'Running the Slideshow Generator (Requires Python 2)'
      puts '---------------------------------------------------'
      output = `python2 #{generate_script}`
      puts output
      puts ''
    end

  end
end
