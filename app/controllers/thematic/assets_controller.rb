#--
# Copyright (c) 2009 Matthew Gibbons
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

class Thematic::AssetsController < ApplicationController
  before_filter :set_request_format
  after_filter { |controller| controller.cache_page }
  
  layout nil

  # GET /(images|javascripts|stylesheets)/:theme/*path
  # Respond with the requested file, or 404 if not found.
  def show
    respond_to do |format|
      format.css {
        if File.file?(stylesheet_filename = theme_public_stylesheets_path(filename))
          send_file stylesheet_filename, :disposition => 'inline', :stream => false, :type => 'text/css'
        elsif File.file?(stylesheet_filename = theme_stylesheets_path(File.join(dirname, "#{basename}.sass")))
          render :text => Sass::Engine.new(File.open(stylesheet_filename).read, sass_options).to_css
        else
          head :not_found
        end
      }
      format.gif {
        if File.file?(image_path = theme_public_images_path(filename))
          send_file image_path, :disposition => 'inline', :stream => false, :type => 'image/gif'
        else
          head :not_found
        end
      }
      format.jpeg {
        if File.file?(image_path = theme_public_images_path(filename))
          send_file image_path, :disposition => 'inline', :stream => false, :type => 'image/jpeg'
        else
          head :not_found
        end
      }
      format.js {        
        if File.file?(javascript_path = theme_public_javascripts_path(filename))
          send_file javascript_path, :disposition => 'inline', :stream => false, :type => 'application/javascript'
        else
          head :not_found
        end
      }
      format.png {
        if File.file?(image_path = theme_public_images_path(filename))
          send_file image_path, :disposition => 'inline', :stream => false, :type => 'image/png'
        else
          head :not_found
        end
      }
    end
  end

  protected
    def set_request_format
      request.format = Mime::Type.lookup_by_extension(extname[1..-1]).to_sym
    end
    
  private
    # The dirname of the requested filename
    def dirname
      File.dirname(filename)
    end
    
    # The requested filename
    def filename
      File.join(params[:path])
    end
  
    # The basename of the requested filename
    def basename(suffix = nil)
      File.basename(filename, suffix || extname)
    end
  
    # The extname of the requested filename
    def extname
      File.extname(filename)
    end
    
    # Options for the Sass engine
    def sass_options
      { 
        :load_paths => [ theme_stylesheets_path, Sass::Plugin.options[:load_paths] ].flatten 
      }
    end

    # The theme
    def theme
      params[:theme]
    end
    
    # The path to the theme's public images
    def theme_public_images_path(source = '')
      File.join(theme_path, 'public', 'images', source)
    end
    
    # The path to the theme's public javascripts
    def theme_public_javascripts_path(source = '')
      File.join(theme_path, 'public', 'javascripts', source)
    end

    # The path to the theme's public stylesheets
    def theme_public_stylesheets_path(source = '')
      File.join(theme_path, 'public', 'stylesheets', source)
    end

    # The path to the theme's public stylesheets
    def theme_stylesheets_path(source = '')
      File.join(theme_path, 'stylesheets', source)
    end

    # The path to the theme
    def theme_path
      File.join(themes_path, theme)
    end
    
    # The base path for themes
    def themes_path
      File.join(RAILS_ROOT, 'themes')
    end
end