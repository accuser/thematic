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

require 'fileutils'

namespace :themes do
  desc "List installed themes"
  task :list do
    puts "The following themes are installed in #{themes_path}: #{installed_themes.to_sentence}."
  end
  
  namespace :cache do
    desc "Expire cached themes"
    task :expire do
      installed_themes.each do |theme|
        FileUtils.remove_dir(File.join(public_images_path, theme)) rescue nil
        FileUtils.remove_dir(File.join(public_javascripts_path, theme)) rescue nil
        FileUtils.remove_dir(File.join(public_stylesheets_path, theme)) rescue nil
      end
    end
  end
  
  private
    def images_path(theme)
      File.join(themes_path(theme), 'images')
    end
  
    def installed_themes
      Dir[File.join(themes_path, '*')].collect do |filename|
        if File.directory?(filename)
          File.basename(filename)
        end
      end.sort
    end
  
    def javascripts_path(theme)
      File.join(themes_path(theme), 'javascripts')
    end
  
    def public_images_path
      File.join(public_path, 'images')
    end
  
    def public_javascripts_path
      File.join(public_path, 'javascripts')
    end
  
    def public_path
      defined?(Rails.public_path) ? Rails.public_path : "public"
    end
  
    def public_stylesheets_path
      File.join(public_path, 'stylesheets')
    end
    
    def public_path
      defined?(Rails.public_path) ? Rails.public_path : "public"
    end
  
    def stylesheets_path(theme)
      File.join(themes_path(theme), 'stylesheets')
    end
  
    def theme_path(theme)
      File.join(themes_path, theme)
    end
  
    def themes_path
      File.join(RAILS_ROOT, 'themes')
    end
end
