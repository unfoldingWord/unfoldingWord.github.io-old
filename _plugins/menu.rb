# Builds the unfoldingWord menus

module Jekyll
    module MenuFilter

        def build(menu)

            permalink = @context.registers[:page]['permalink']
            permalink = '' if permalink.nil?
            permalink = permalink.sub('/index.html', '')

            baseUrl = @context.registers[:site].config['baseurl']

            returnVal = ''
            menu.each do |itm|
                returnVal << addItem(itm, permalink, baseUrl)
            end

            returnVal
        end

        def addItem(menuItem, permalink, baseUrl)

            cls = 'menu-item'
            hasSub = menuItem['subitems'] != nil
            href = menuItem['href'] == nil ? '#' : menuItem['href']

            # is this the current page menu item?
            if menuItem['href'] == permalink
                cls << ' current-menu-item'
            end

            # does this item need an additional dropdown sub-menu?
            if hasSub
                cls << ' menu-item-has-children'
            end

            returnVal = '<li class="' + cls + '">'
            returnVal << '<a href="' + baseUrl + href + '">' + menuItem['title'] + '</a>'

            if hasSub
                returnVal << addSubMenu(menuItem, permalink, baseUrl)
            end

            returnVal << "</li>\n"

            returnVal
        end

        def addSubMenu(menuItem, permalink, baseUrl)

            returnVal = "\n<ul class=\"sub-menu\">\n"

            menuItem['subitems'].each do |itm|
                returnVal << addItem(itm, permalink, baseUrl)
            end

            returnVal << "</ul>\n"

            returnVal
        end

        private :addItem, :addSubMenu
    end
end

Liquid::Template.register_filter(Jekyll::MenuFilter)
