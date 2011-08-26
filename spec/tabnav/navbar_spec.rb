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
  end

  describe "render_navbar" do
    before :each do
      @template = ActionView::Base.new()
    end

    it "should output nothing if no tabs have been added" do
      n = Tabnav::Navbar.new(@template, {})
      n.render_navbar.should == ''
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

    it "should pass the options given on creation to the ul" do
      n = Tabnav::Navbar.new(@template, {}, :id => "my_id", :class => "my_class")
      t1 = nil
      n.add_tab do |t|
        t1 = t
      end
      @template.should_receive(:content_tag).with(:ul, {:id => "my_id", :class => "my_class"}).and_return(:some_markup)
      n.render_navbar.should == :some_markup
    end
  end
end
