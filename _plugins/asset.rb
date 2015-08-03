# Looks up an asset and returns the URL or REV

module Jekyll
  module AssetFilter

    def url(asset_id)
      @context.registers[:site].data['assets'][asset_id]['url']
    end

    def rev(asset_id)
      @context.registers[:site].data['assets'][asset_id]['rev']
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
