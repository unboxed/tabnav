require 'spec_helper'

describe Tabnav::Navbar do

  describe "add_tab" do
    before :each do
      @template = ActionView::Base.new()
    end

    it "should create a new tab with the passed template and params and yield it to the block" do
      n = Tabnav::Navbar.new(@template, {"foo" => "bar"})
      t = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {"foo" => "bar"}, {}).and_return(t)
      n.add_tab do |t|
        t.should == t
      end
    end

    it "should create the tab with any passed options" do
      n = Tabnav::Navbar.new(@template, {})
      t = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:class => "my_class", :id => "my_id"}).and_return(t)
      n.add_tab :class => "my_class", :id => "my_id" do |t|
        t.should == t
      end
    end

    it "should add the custom partial to the options if set" do
      n = Tabnav::Navbar.new(@template, {})
      n.tab_content_partial = 'my_partial'
      t = Tabnav::Tab.new(@template, {})
      Tabnav::Tab.should_receive(:new).with(@template, {}, {:id => "my_id", :tab_content_partial => 'my_partial'}).and_return(t)
      n.add_tab :id => "my_id" do |t|
        t.should == t
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

#     it "should output a li containing a span with the name if no link given" do
#       t = Tabnav::Tab.new(@template)
#       t.named "A Tab"
#       html = t.render
#       html.should == "<li><span>A Tab</span></li>"
#     end
#
#     it "should output a li containing a link with the name" do
#       t = Tabnav::Tab.new(@template)
#       t.named "A Tab"
#       t.links_to "/wibble"
#       html = t.render
#       html.should == "<li><a href=\"/wibble\">A Tab</a></li>"
#     end
#
#     context "with no name given" do
#       it "should output a blank tab if no link given" do
#         t = Tabnav::Tab.new(@template)
#         html = t.render
#         html.should == "<li><span></span></li>"
#       end
#
#       it "should output an empty link" do
#         t = Tabnav::Tab.new(@template)
#         t.links_to "/wibble"
#         html = t.render
#         html.should == "<li><a href=\"/wibble\"></a></li>"
#       end
#     end
#
#     it "should pass the options given on creation to the li" do
#       @template.should_receive(:content_tag).with(:li, {:id => "my_id", :class => "my_class"}).and_return(:some_markup)
#       t = Tabnav::Tab.new(@template, :id => "my_id", :class => "my_class")
#       t.named "A Tab"
#       t.render.should == :some_markup
#     end
#
#     it "should pass the options given to the link to link_to" do
#       @template.should_receive(:link_to).with("A Tab", "/wibble", {:class => "link_class", :target => "_blank"}).and_return("A Link")
#       t = Tabnav::Tab.new(@template)
#       t.named "A Tab"
#       t.links_to "/wibble", :class => "link_class", :target => "_blank"
#       html = t.render
#       html.should == "<li>A Link</li>"
#     end
  end
end
