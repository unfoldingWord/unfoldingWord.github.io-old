# Looks up an asset and returns the URL or REV

module Jekyll
  module AssetFilter

    def url(assetId)
      @context.registers[:site].data['assets'][assetId]['url']
    end

    def rev(assetId)
      @context.registers[:site].data['assets'][assetId]['rev']
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
