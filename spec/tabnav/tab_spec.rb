require 'spec_helper'

describe Tabnav::Tab do

  describe "render" do
    before :each do
      @template = ActionView::Base.new()
    end
    it "should output a li containing a span with the name if no link given" do
      t = Tabnav::Tab.new(@template)
      t.named "A Tab"
      html = t.render
      html.should == "<li><span>A Tab</span></li>"
    end

    it "should output a li containing a link with the name" do
      t = Tabnav::Tab.new(@template)
      t.named "A Tab"
      t.links_to "/wibble"
      html = t.render
      html.should == "<li><a href=\"/wibble\">A Tab</a></li>"
    end

    it "should pass the options given on creation to the li" do
      @template.should_receive(:content_tag).with(:li, {:id => "my_id", :class => "my_class"}).and_return(:some_markup)
      t = Tabnav::Tab.new(@template, :id => "my_id", :class => "my_class")
      t.named "A Tab"
      t.render.should == :some_markup
    end

    it "should pass the options given to the link to link_to" do
      @template.should_receive(:link_to).with("A Tab", "/wibble", {:class => "link_class", :target => "_blank"}).and_return("A Link")
      t = Tabnav::Tab.new(@template)
      t.named "A Tab"
      t.links_to "/wibble", :class => "link_class", :target => "_blank"
      html = t.render
      html.should == "<li>A Link</li>"
    end
  end
end
