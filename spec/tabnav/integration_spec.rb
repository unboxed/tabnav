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

  describe "nested navbars" do
    it "should allow a nested navbar" do
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to '/'
          t.highlights_on :controller => :home, :action => :index
        end

        n.add_sub_nav do |sn|
          sn.named "Froobles"

          sn.add_tab do |t|
            t.named "All Froobles"
            t.links_to '/froobles'
            t.highlights_on :controller => :froobles, :action => :index
          end

          sn.add_tab do |t|
            t.named "New Frooble"
            t.links_to '/froobles/new'
            t.highlights_on :controller => :froobles, :action => :new
            t.highlights_on :controller => :froobles, :action => :create
          end
        end

        n.add_tab do |t|
          t.named "Something Else"
          t.links_to "/somewhere"
        end
      end
      helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li><span>Froobles</span>' +
        '<ul><li><a href="/froobles">All Froobles</a></li><li><a href="/froobles/new">New Frooble</a></li></ul>' +
        '</li><li><a href="/somewhere">Something Else</a></li></ul>'
    end

    it "should allow specifying class/id on a nested navbar" do
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to '/'
          t.highlights_on :controller => :home, :action => :index
        end

        n.add_sub_nav :id => 'froobles' do |sn|
          sn.named "Froobles"

          sn.add_tab do |t|
            t.named "All Froobles"
            t.links_to '/froobles'
            t.highlights_on :controller => :froobles, :action => :index
          end

          sn.add_tab do |t|
            t.named "New Frooble"
            t.links_to '/froobles/new'
            t.highlights_on :controller => :froobles, :action => :new
            t.highlights_on :controller => :froobles, :action => :create
          end
        end

        n.add_tab do |t|
          t.named "Something Else"
          t.links_to "/somewhere"
        end
      end
      helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li id="froobles"><span>Froobles</span>' +
        '<ul><li><a href="/froobles">All Froobles</a></li><li><a href="/froobles/new">New Frooble</a></li></ul>' +
        '</li><li><a href="/somewhere">Something Else</a></li></ul>'
    end

    it "highlighting logic should work on a subnavbar" do
      controller.params['controller'] = 'wibble'
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to '/'
          t.highlights_on :controller => :home, :action => :index
        end

        n.add_sub_nav do |sn|
          sn.named "Froobles"
          sn.highlights_on :controller => :wibble

          sn.add_tab do |t|
            t.named "All Froobles"
            t.links_to '/froobles'
            t.highlights_on :controller => :froobles, :action => :index
          end

          sn.add_tab do |t|
            t.named "New Frooble"
            t.links_to '/froobles/new'
            t.highlights_on :controller => :froobles, :action => :new
            t.highlights_on :controller => :froobles, :action => :create
          end
        end
      end
      helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li class="active"><span>Froobles</span>' +
        '<ul><li><a href="/froobles">All Froobles</a></li><li><a href="/froobles/new">New Frooble</a></li></ul>' +
        '</li></ul>'
    end

    it "should allow deep nesting of navbars" do
      helper.render_tabnav do |n|
        n.add_tab do |t|
          t.named "Home"
          t.links_to '/'
        end

        n.add_sub_nav do |sn|
          sn.named "Foo"

          sn.add_tab do |t|
            t.named "All Foos"
            t.links_to '/foos'
          end

          sn.add_sub_nav do |ssn|
            ssn.named "Bars"
            ssn.links_to '/foos/bars'

            ssn.add_tab do |t|
              t.named "New Bar"
              t.links_to '/foos/bars/new'
            end

            ssn.add_tab do |t|
              t.named "Wibble"
              t.highlights_on Proc.new { true }
            end
          end
        end
      end
      helper.output_buffer.should == '<ul><li><a href="/">Home</a></li><li><span>Foo</span>' +
          '<ul><li><a href="/foos">All Foos</a></li><li>' +
            '<a href="/foos/bars">Bars</a>' + 
            '<ul><li><a href="/foos/bars/new">New Bar</a></li><li class="active"><span>Wibble</span></li></ul>' + 
          '</li></ul>' +
        '</li></ul>'
    end
  end
end
