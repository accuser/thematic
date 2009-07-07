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

class Thematic::StylesheetsController < ApplicationController
  after_filter { |controller| controller.cache_page }
  
  layout nil

  # GET /stylesheets/:theme_id/:id.css
  # Respond with the requested stylesheet file, or 404 if not found.
  def show
    basename = File.basename(params[:id])

    respond_to do |format|
      format.css {
        if File.file?(filename = theme_public_stylesheets_path(basename))
          send_file filename, :stream => false, :type => 'text/css', :disposition => 'inline'
        elsif File.file?(filename = theme_stylesheets_path(basename, 'sass'))
          ::ActionController::Base.headers['Content-Type'] = 'text/css'
          render :text => Sass::Engine.new(File.open(filename).read).to_css
        elsif File.file?(filename = public_stylesheets_path(basename))
          send_file filename, :stream => false, :type => 'text/css', :disposition => 'inline'
        else
          render :nothing => true, :status => :not_found
        end
      }
    end
  end
  
  private
    # The default public path
    def public_path
      File.join(RAILS_ROOT, 'public')
    end
    
    # The path to the default public stylesheets
    def public_stylesheets_path(source, ext = 'css')
      File.join(public_path, 'stylesheets', "#{source}.#{ext.to_s}")
    end
        
    # The path to the theme
    def theme_path
      File.join(themes_path, "#{params[:theme_id]}")
    end

    # The path to the theme's public stylesheets
    def theme_public_stylesheets_path(source, ext = 'css')
      File.join(theme_path, 'public', 'stylesheets', "#{source}.#{ext.to_s}")
    end
    
    # The path the theme's stylesheet sources
    def theme_stylesheets_path(source, ext = 'css')
      File.join(theme_path, 'stylesheets', "#{source}.#{ext.to_s}")
    end
    
    # The base path for themes
    def themes_path
      File.join(RAILS_ROOT, 'themes')
    end
end