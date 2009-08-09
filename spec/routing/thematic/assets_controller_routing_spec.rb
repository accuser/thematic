require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))
  
describe Thematic::AssetsController do
  IMAGE_FORMATS = [ 'gif', 'jpe', 'jpeg', 'jpg', 'png' ].freeze
  JAVASCRIPT_FORMATS = [ 'js' ].freeze
  STYLESHEET_FORMATS = [ 'css' ].freeze
  
  describe "route generation" do
    describe "for image assets" do
      it "maps #show" do
        IMAGE_FORMATS.each do |format|
          route_for(:controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ]).should == "/images/my_theme/path/to/file.#{format}"
        end
      end
    end
    
    describe "for javascript assets" do
      it "maps #show" do
        JAVASCRIPT_FORMATS.each do |format|
          route_for(:controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ]).should == "/javascripts/my_theme/path/to/file.#{format}"
        end
      end
    end
    
    describe "for stylesheet assets" do
      it "maps #show" do
        STYLESHEET_FORMATS.each do |format|
          route_for(:controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ]).should == "/stylesheets/my_theme/path/to/file.#{format}"
        end
      end
    end
  end
  
  describe "route recognition" do
    describe "for image assets" do
      it "generates params for #show" do
        IMAGE_FORMATS.each do |format|
          params_from(:get, "/images/my_theme/path/to/file.#{format}").should ==  { :controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ] }
        end
      end
    end

    describe "for javascript assets" do
      it "generates params for #show" do
        JAVASCRIPT_FORMATS.each do |format|
          params_from(:get, "/javascripts/my_theme/path/to/file.#{format}").should ==  { :controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ] }
        end
      end
    end

    describe "for stylesheets assets" do
      it "generates params for #show" do
        STYLESHEET_FORMATS.each do |format|
          params_from(:get, "/stylesheets/my_theme/path/to/file.#{format}").should ==  { :controller => 'thematic/assets', :action => 'show', :theme => 'my_theme', :path => [ 'path', 'to', "file.#{format}" ] }
        end
      end
    end
  end
end