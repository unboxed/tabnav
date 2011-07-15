require 'spec_helper'

describe Tabnav::Helper, :type => :helper do
  before :each do
    helper.output_buffer = ''
  end

  describe "basic flat navbar" do
    it "should output a basic 2 tab navbar" do
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to "/"
        end
        n.add_tab do |t|
          t.named "Froobles"
          t.links_to "/froobles"
        end
      end
      helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li><a href="/froobles">Froobles</a></li></ul>'
    end

    it "should output a basic 2 tab navbar with extra markup options" do
      helper.render_tabnav :id => "main_navigation", :class => "clearfix" do |n|
        n.add_tab :class => "home_tab" do |t|
          t.named "Home"
          t.links_to "/"
        end
        n.add_tab :class => "heading" do |t|
          t.named "Froobles Heading"
        end
        n.add_tab do |t|
          t.named "Froobles"
          t.links_to "/froobles", :target => "_blank", :rel => "http://foo.bar/"
        end
      end
      helper.output_buffer.should == '<ul class="clearfix" id="main_navigation"><li class="home_tab"><a href="/">Home</a></li>' +
          '<li class="heading"><span>Froobles Heading</span></li>' +
          '<li><a href="/froobles" rel="http://foo.bar/" target="_blank">Froobles</a></li></ul>'
    end

    it "should return nil (avoid double render bug)" do
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to "/"
        end
        n.add_tab do |t|
          t.named "Froobles"
          t.links_to "/froobles"
        end
      end.should == nil
    end
  end

  describe "highlighting logic" do
    context "params based rules" do
      it "should highlight the tab if the rules match the params hash" do
        controller.params["controller"] = 'home'
        controller.params["action"] = 'index'
        controller.params["foo"] = 'bar'
        helper.render_tabnav :id => "main_navigation", :class => "clearfix" do |n|
          n.add_tab :class => "home_tab" do |t|
            t.named "Home"
            t.links_to '/'
            t.highlights_on :controller => 'home', :action => 'index'
          end
          n.add_tab :class => "heading" do |t|
            t.named "Froobles Heading"
            t.highlights_on :controller => :froobles
          end
          n.add_tab do |t|
            t.named "Froobles"
            t.links_to '/froobles', :target => "_blank", :rel => "http://foo.bar/"
            t.highlights_on :controller => :froobles, :action => :index
          end
        end
        helper.output_buffer.should == '<ul class="clearfix" id="main_navigation"><li class="home_tab active"><a href="/">Home</a></li>' +
            '<li class="heading"><span>Froobles Heading</span></li>' +
            '<li><a href="/froobles" rel="http://foo.bar/" target="_blank">Froobles</a></li></ul>'
      end

      it "should allow multiple tabs to be active at once" do
        controller.params['controller'] = 'froobles'
        controller.params['action'] = 'index'
        controller.params['foo'] = 'bar'
        helper.render_tabnav do |n|
          n.add_tab :class => "home_tab" do |t|
            t.named "Home"
            t.links_to '/'
            t.highlights_on :controller => :home, :action => :index
          end
          n.add_tab :class => "heading" do |t|
            t.named "Froobles Heading"
            t.highlights_on :controller => :froobles
          end
          n.add_tab do |t|
            t.named "Froobles"
            t.links_to '/froobles', :target => "_blank", :rel => "http://foo.bar/"
            t.highlights_on :controller => :froobles, :action => :index
          end
        end
        helper.output_buffer.should == '<ul><li class="home_tab"><a href="/">Home</a></li>' +
            '<li class="heading active"><span>Froobles Heading</span></li>' +
            '<li class="active"><a href="/froobles" rel="http://foo.bar/" target="_blank">Froobles</a></li></ul>'
      end

      it "should highlight tabs where any of the highlighting rules match" do
        controller.params['controller'] = 'home'
        controller.params['action'] = 'froobles'
        controller.params['foo'] = 'bar'
        helper.render_tabnav do |n|
          n.add_tab do |t|
            t.named "Home"
            t.links_to "/"
            t.highlights_on :controller => :home, :action => :index
          end
          n.add_tab do |t|
            t.named "Froobles"
            t.links_to "/froobles"
            t.highlights_on :controller => :home, :action => :froobles
            t.highlights_on :controller => :froobles
          end
        end
        helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li class="active"><a href="/froobles">Froobles</a></li></ul>'
      end
    end

    context "proc based rules" do
      it "should highlight the tab if the give proc evaluates to true" do
        helper.render_tabnav do |n|
          n.add_tab do |t|
            t.named "Home"
            t.links_to "/"
            t.highlights_on Proc.new { true }
          end
          n.add_tab do |t|
            t.named "Froobles"
            t.links_to "/froobles"
            t.highlights_on Proc.new { false }
          end
        end
        helper.output_buffer.should == '<ul><li class="active"><a href="/">Home</a></li><li><a href="/froobles">Froobles</a></li></ul>'
      end
    end

    it "should allow a mixture of rule types" do
      controller.params['controller'] = 'home'
      controller.params['action'] = 'index'
      controller.params['foo'] = 'bar'
      helper.render_tabnav do |n|
        n.add_tab :class => "home_tab" do |t|
          t.named "Home"
          t.links_to '/'
          t.highlights_on :controller => :home, :action => :index
        end
        n.add_tab :class => "heading" do |t|
          t.named "Froobles Heading"
          t.highlights_on :controller => :froobles
          t.highlights_on Proc.new { true }
        end
        n.add_tab do |t|
          t.named "Froobles"
          t.links_to '/froobles', :target => "_blank", :rel => "http://foo.bar/"
          t.highlights_on :controller => :froobles, :action => :index
        end
      end
      helper.output_buffer.should == '<ul><li class="home_tab active"><a href="/">Home</a></li>' +
          '<li class="heading active"><span>Froobles Heading</span></li>' +
          '<li><a href="/froobles" rel="http://foo.bar/" target="_blank">Froobles</a></li></ul>'
    end
  end

  describe "custom tab partials" do
    it "should allow sppecifying a custom partial for rendering the tabs" do
      helper.should_receive(:render).twice do |args|
        args[:partial].should == '/tab_content'
        args[:locals][:tab].should be_a(Tabnav::Tab)
        "Custom markup for #{args[:locals][:tab].name}"
      end
      helper.render_tabnav do |n|
        n.tab_content_partial = '/tab_content'
        n.add_tab do |t|
          t.named "Home"
          t.links_to "/"
        end
        n.add_tab do |t|
          t.named "Froobles"
          t.links_to "/froobles"
        end
      end
      helper.output_buffer.should ==
          '<ul><li>Custom markup for Home</li>' +
          '<li>Custom markup for Froobles</li></ul>'
    end
  end
end
