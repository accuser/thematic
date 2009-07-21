# This generator creates a new theme for use with Thematic
class ThemeGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory('themes')
      m.directory(File.join('themes', name))
      m.directory(File.join('themes', name, 'public'))
      m.directory(File.join('themes', name, 'public', 'images'))
      m.directory(File.join('themes', name, 'public', 'javascripts'))
      m.directory(File.join('themes', name, 'public', 'stylesheets'))
      m.directory(File.join('themes', name, 'stylesheets'))
      m.directory(File.join('themes', name, 'views'))
      m.directory(File.join('themes', name, 'views', 'layouts'))
    end
  end

protected
  def banner
    "Usage: #{$0} theme theme_name"
  end
end
