require 'spec_helper'

describe Tabnav::Navbar do

  describe "add_tab" do
    before :each do
      @template = ActionView::Base.new()
    end

    it "should create a new tab with the passed template and params and yield it to the block" do
      n = Tabnav::Navbar.new(@template, {"foo" => "bar"})
      tab = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {"foo" => "bar"}, {}).and_return(tab)
      n.add_tab do |t|
        t.should == tab
      end
    end

    it "should create the tab with any passed options" do
      n = Tabnav::Navbar.new(@template, {})
      tab = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:class => "my_class", :id => "my_id"}).and_return(tab)
      n.add_tab :class => "my_class", :id => "my_id" do |t|
        t.should == tab
      end
    end

    it "should add the custom partial to the options if set" do
      n = Tabnav::Navbar.new(@template, {})
      n.tab_content_partial = 'my_partial'
      tab = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(tab)
      n.add_tab :id => "my_id" do |t|
        t.should == tab
      end
    end

    it "should add the tabnav's partial to the options if one was set" do
      n = Tabnav::Navbar.new(@template, {}, :tab_content_partial => 'my_partial')
      tab = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(tab)
      n.add_tab :id => "my_id" do |t|
        t.should == tab
      end
    end

    it "should use the custom partial in preference to the navbars partial" do
      n = Tabnav::Navbar.new(@template, {}, :tab_content_partial => 'my_other_partial')
      n.tab_content_partial = 'my_partial'
      tab = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(tab)
      n.add_tab :id => "my_id" do |t|
        t.should == tab
      end
    end
  end

  describe "add_sub_nav" do
    before :each do
      @template = ActionView::Base.new()
    end

    it "should create a new navbar with the passed template and params and yield it to the block" do
      n = Tabnav::Navbar.new(@template, {"foo" => "bar"})
      subnav = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.should_receive(:new).with(@template, {"foo" => "bar"}, {}).and_return(subnav)
      n.add_sub_nav do |sn|
        sn.should == subnav
      end
    end

    it "should create the tab with any passed options" do
      n = Tabnav::Navbar.new(@template, {})
      subnav = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.should_receive(:new).with(@template, {}, {:class => "my_class", :id => "my_id"}).and_return(subnav)
      n.add_sub_nav :class => "my_class", :id => "my_id" do |sn|
        sn.should == subnav
      end
    end

    it "should add the custom partial to the options if set" do
      n = Tabnav::Navbar.new(@template, {})
      n.tab_content_partial = 'my_partial'
      subnav = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(subnav)
      n.add_sub_nav :id => "my_id" do |sn|
        sn.should == subnav
      end
    end

    it "should add the tabnav's partial to the options if one was set" do
      n = Tabnav::Navbar.new(@template, {}, :tab_content_partial => 'my_partial')
      subnav = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(subnav)
      n.add_sub_nav :id => "my_id" do |sn|
        sn.should == subnav
      end
    end

    it "should use the custom partial in preference to the navbars partial" do
      n = Tabnav::Navbar.new(@template, {}, :tab_content_partial => 'my_other_partial')
      n.tab_content_partial = 'my_partial'
      subnav = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(subnav)
      n.add_sub_nav :id => "my_id" do |sn|
        sn.should == subnav
      end
    end
  end

  describe "Tab behaviour" do
    it "should be a subclass of Tab" do
      Tabnav::Navbar.new(nil, nil).should be_a(Tabnav::Tab)
    end
  end

  describe "render_navbar" do
    before :each do
      @template = ActionView::Base.new()
    end

    it "should output nothing if no tabs have been added" do
      n = Tabnav::Navbar.new(@template, {})
      html = n.render_navbar
      html.should == ''
      html.should be_html_safe
    end

    it "should output a ul containing the results of rendering each of it's tabs" do
      n = Tabnav::Navbar.new(@template, {})
      t1 = t2 = nil
      n.add_tab do |t|
        t1 = t
      end
      n.add_tab do |t|
        t2 = t
      end
      t1.should_receive(:render).and_return("Tab 1 markup")
      t2.should_receive(:render).and_return("Tab 2 markup")
      n.render_navbar.should == '<ul>Tab 1 markupTab 2 markup</ul>'
    end

    it "should pass the options given on creation to the ul when it's the top-level navbar" do
      n = Tabnav::Navbar.new(@template, {}, :id => "my_id", :class => "my_class", :top_level => true)
      t1 = nil
      n.add_tab do |t|
        t1 = t
      end
      @template.should_receive(:content_tag).with(:ul, {:id => "my_id", :class => "my_class"}).and_return(:some_markup)
      n.render_navbar.should == :some_markup
    end

    it "should pass the container_html options to the ul when it's not the top-level navbar" do
      n = Tabnav::Navbar.new(@template, {}, :id => "my_id", :class => "my_class", :container_html => { :id => "ul_id", :class => "ul_class" })
      t1 = nil
      n.add_tab do |t|
        t1 = t
      end
      @template.should_receive(:content_tag).with(:ul, { :id => "ul_id", :class => "ul_class" }).and_return(:some_markup)
      n.render_navbar.should == :some_markup
    end
  end

  describe "render" do
    # This only covers the functionality specific to navbars, the rest is covered in tab_spec
    before :each do
      @template = ActionView::Base.new()
    end
    it "should insert the navbar inside the end of the li" do
      n = Tabnav::Navbar.new(@template, {})
      n.stub!(:render_navbar).and_return("The Navbar")
      n.named "A Tab"
      html = n.render
      html.should == "<li><span>A Tab</span>The Navbar</li>"
      html.should be_html_safe
    end
  end
end
