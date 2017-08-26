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

  end
end

Liquid::Template.register_filter(Jekyll::ManifestFilter)
