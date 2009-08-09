require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Thematic::AssetsController do
  before(:each) do
    controller.stub(:themes_path).and_return(THEMES_PATH)
  end

  describe "GET #show" do
    describe "when requesting an image asset" do
      describe "with extension .gif" do
        describe "that exists" do          
          it "responds by sending the file to the client" do
            controller.should_receive(:send_file).with(File.join(THEMES_PATH, 'test_theme', 'public', 'images', 'image.gif'), :disposition => 'inline', :stream => false, :type => 'image/gif')
            get :show, :theme => 'test_theme', :path => [ 'image.gif' ]
          end
        end
        
        describe "that does not exist" do 
          it "responds with '404 Not Found'" do
            get :show, :theme => 'test_theme', :path => [ 'non_existent_image.gif' ]
            response.response_code.should == 404
          end
        end
      end

      describe "with extension .jpeg" do
        describe "that exists" do          
          it "responds by sending the file to the client" do
            controller.should_receive(:send_file).with(File.join(THEMES_PATH, 'test_theme', 'public', 'images', 'image.jpeg'), :disposition => 'inline', :stream => false, :type => 'image/jpeg')
            get :show, :theme => 'test_theme', :path => [ 'image.jpeg' ]
          end
        end
        
        describe "that does not exist" do 
          it "responds with '404 Not Found'" do
            get :show, :theme => 'test_theme', :path => [ 'non_existent_image.jpeg' ]
            response.response_code.should == 404
          end
        end
      end

      describe "with extension .png" do
        describe "that exists" do          
          it "responds by sending the file to the client" do
            controller.should_receive(:send_file).with(File.join(THEMES_PATH, 'test_theme', 'public', 'images', 'image.png'), :disposition => 'inline', :stream => false, :type => 'image/png')
            get :show, :theme => 'test_theme', :path => [ 'image.png' ]
          end
        end
        
        describe "that does not exist" do 
          it "responds with '404 Not Found'" do
            get :show, :theme => 'test_theme', :path => [ 'non_existent_image.png' ]
            response.response_code.should == 404
          end
        end
      end
    end

    describe "when requesting a javascript asset" do
      describe "with extension .js" do
        describe "that exists" do          
          it "responds by sending the file to the client" do
            controller.should_receive(:send_file).with(File.join(THEMES_PATH, 'test_theme', 'public', 'javascripts', 'javascript.js'), :disposition => 'inline', :stream => false, :type => 'application/javascript')
            get :show, :theme => 'test_theme', :path => [ 'javascript.js' ]
          end
        end
        
        describe "that does not exist" do 
          it "responds with '404 Not Found'" do
            get :show, :theme => 'test_theme', :path => [ 'non_existent_javascript.js' ]
            response.response_code.should == 404
          end
        end
      end
    end

    describe "when requesting a stylesheet asset" do
      describe "with extension .css" do
        describe "that exists" do          
          it "responds by sending the file to the client" do
            controller.should_receive(:send_file).with(File.join(THEMES_PATH, 'test_theme', 'public', 'stylesheets', 'stylesheet.css'), :disposition => 'inline', :stream => false, :type => 'text/css')
            get :show, :theme => 'test_theme', :path => [ 'stylesheet.css' ]
          end
        end
        
        describe "that does not exist" do 
          it "responds with '404 Not Found'" do
            get :show, :theme => 'test_theme', :path => [ 'non_existent_stylesheet.css' ]
            response.response_code.should == 404
          end
        end
      end
    end
  end
end  
