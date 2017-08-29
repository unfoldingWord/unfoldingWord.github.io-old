# Manipulates manifest data

module Jekyll
  module ManifestFilter

    # Retrieves manifest data for the given DublinCore identifier
    # @param [String] dc_id
    # @return [Object]
    def get_by_dc_id(dc_id)

      site_data = @context.registers[:site].data
      unless site_data.key?('content')
        return nil
      end

      # found will contain an array: found[0] is the key, found[1] is the value
      found = site_data['content'].find {|_,itm| itm['dublin_core']['identifier'] == dc_id}

      if found
        return found[1]
      end

      nil
    end

    # Retrieves a sorted list of the projects in this manifest
    # @param [Object] manifest
    # @return [Object]
    def get_sorted_scripture_projects(manifest)

      projects = manifest['projects']
      usfm_data = @context.registers[:site].data['usfm_numbers']

      # get the USFM code for this project (01-GEN)
      projects.each do |proj|

        found = usfm_data.find {|k,_| k == proj['identifier'].upcase}


        proj['usfm_code'] = found[1][1] + '-' + found[0]

        # some manifests do not contain the name of the book in the project name, so add it here
        proj['usfm_name'] = found[1][0]
      end

      projects.sort_by {|proj| proj['usfm_code']}
    end
  end
end

Liquid::Template.register_filter(Jekyll::ManifestFilter)
