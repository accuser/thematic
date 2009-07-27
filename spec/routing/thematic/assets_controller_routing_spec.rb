require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))
  
describe Thematic::AssetsController do
  FORMATS = [ 'css', 'gif', 'jpe', 'jpeg', 'jpg', 'js', 'png' ].freeze
  
  describe "route generation" do
    it "maps #show" do
      FORMATS.each do |format|
        route_for(:controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ]).should == "/images/my_theme/path/to/file.#{format}"
      end
    end
  end
  
  describe "route recognition" do
    it "generates params for #show" do
      FORMATS.each do |format|
        params_from(:get, "/images/my_theme/path/to/file.#{format}").should ==  { :controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ] }
      end
    end
  end
end