Thematic
========

Plugin that adds support for themes to Ruby on Rails websites.

Overview
--------

The thematic plugin modifies the Rails ActionView::Helpers::AssetTagHelper 
module so that asset paths (e.g. /stylesheets/style.css) can be written to 
include dynamic named themes (e.g. /stylesheets/my_theme/style.css). This theme
name is only included when the active controller implements the :theme 
method.

The plugin also includes controllers for each of the asset types, and some
automagic routing to make sure everything works. Basically, a request for an
asset is handled by the respective controller, returned and cached. The request
URL is used for caching, so the returned asset is written to the public folder,
and next time it is requested, it is handled by the webserver and not Rails.

Themes are installed in the themes folder in the root directory of the Rails
application tree, for example:

    RAILS_ROOT/
    + themes/
      + my_theme/
        + public/
          + images/      # images (.gif, .jpeg, .jpg and .png)
          + javascripts/ # scripts (.js)
          + stylesheets/ # static/compiled stylesheets (.css)
        + stylesheets    # CSS sources (.sass) - you're using Sass, aren't you?
        + views/         # view templates
          + layouts/     # view layout templates
          + posts/       # controller/action templates and partial templates, etc.

Getting Started
---------------

Install the plugin:

    script/plugin install git://github.com/accuser/thematic.git
   
Generate thematic support:

    script/generate thematic
   
Generate a theme:

    script/generate theme my_theme
   
Add a theme selector method to your ApplicationController:

    class ApplicationController < ActionController::Base
      theme 'my_theme'
    end
    
or:

    class ApplicationController < ActionController::Base
      theme :choose_theme
      
      def choose_theme
        if request.host =~ /^mobile/
          'mobile'
        end
      end
    end

Add public assets, Sass stylesheet templates, views, etc. to your theme.

Rake Tasks
----------

Themaitc includes a couple of Rake tasks for your pleasure:

    rake themes:list

Show a list of installed themes.
  
    rake themes:cache:expire

Remove *all* cached theme files (images, scripts, stylesheets) from the
public folder.
   
Roadmap
-------

- Add support for installing themes _a la_ script/plugin.
- Add support for child themes

Copyright (c) 2009 Matthew Gibbons, released under the MIT license
