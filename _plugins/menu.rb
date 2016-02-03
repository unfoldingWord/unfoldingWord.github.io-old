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

            cls = ''
            hasSub = menuItem['subitems'] != nil
            href = menuItem['href'] == nil ? '#' : menuItem['href']

            # is this the current page menu item?
            if menuItem['href'] == permalink
                cls << ' active'
            end

            # does this item need an additional dropdown sub-menu?
            if hasSub
                returnVal = '<li class="dropdown' + cls +'">'
                returnVal << '<a href="' + baseUrl + href + '" aria-haspopup="true" aria-expanded="false">' + menuItem['title'] + '</a> <button type="button" class="btn btn-nav-dark dropdown-toggle" data-toggle="dropdown"><span class="fa fa-caret-down"></span><span class="fa fa-caret-up"></span></button>'
                returnVal << addSubMenu(menuItem, permalink, baseUrl)
            else
              returnVal = '<li class="' + cls + '">'
              returnVal << '<a href="' + baseUrl + href + '">' + menuItem['title'] + '</a>'
            end

            returnVal << "</li>\n"

            returnVal
        end

        def addSubMenu(menuItem, permalink, baseUrl)

            returnVal = "\n<ul class=\"dropdown-menu dropdown-menu-left\">\n"

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
