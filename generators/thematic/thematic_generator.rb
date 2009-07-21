# This generator bootstraps a Ruby on Rails project for use with Thematic
class ThematicGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'config'
      m.directory File.join('config', 'initializers')
      
      m.file 'thematic.rb', File.join('config', 'initializers', 'thematic.rb')
    end
  end

protected
  def banner
    "Usage: #{$0} thematic"
  end
end
