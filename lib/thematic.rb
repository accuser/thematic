require 'action_view/helpers/asset_tag_helper'

module Thematic
  # Thematic version
  VERSION = '0.2.0'
end

module ActionController
  class Base
    def self.theme(theme)
      write_inheritable_attribute(:theme, theme)
    end
    
    def default_theme
      theme = self.class.read_inheritable_attribute(:theme)
      
      case theme
      when Symbol
        __send__ theme
      when Proc
        call theme(self)
      else
        theme
      end
    end
    
    protected
      def render_with_theme(options = nil, extra_options = {}, &block)
        # Get the theme if it has been supplied as an option
        theme = extra_options.delete(:theme)
        
        # If the theme has not been supplied as an option, get the default theme
        theme ||= default_theme

        if theme
          # Add the theme's view path to the front of the view paths
          prepend_view_path(File.join(RAILS_ROOT, 'themes', theme.to_s, 'views'))
        end
        
        # Call the #render method chain
        if block
          render_without_theme(options, extra_options) do
            block.call
          end
        else
          render_without_theme(options, extra_options)
        end
      end
      
      alias_method_chain :render, :theme
  end
end

module ActionView
  module Helpers #:nodoc:
    module AssetTagHelper
      private
        def compute_public_path_with_theme(source, dir, ext = nil, include_host = true)
          default_theme = @controller.default_theme

          # Add the theme name to the asset dir
          if default_theme
            dir = "#{dir}/#{default_theme}"
          end
          
          # Call the #compute_public_path method chain
          compute_public_path_without_theme(source, dir, ext, include_host)
        end
        
        alias_method_chain :compute_public_path, :theme
    end
  end
end