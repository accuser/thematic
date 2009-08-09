begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

unless defined?(THEMES_PATH)
  THEMES_PATH = File.join(File.dirname(__FILE__), 'fixtures', 'themes')
end