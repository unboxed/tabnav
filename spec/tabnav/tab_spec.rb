require 'spec_helper'

describe Tabnav::Tab do
  
  describe "render" do
    before :each do
      @template = ActionView::Base.new()
    end
    it "should output a li containing a span with the name if no link given" do
      t = Tabnav::Tab.new
      t.named "A Tab"
      html = t.render(@template)
      html.should == "<li><span>A Tab</span></li>"
    end
    
    it "should output a li containing a link with the name" do
      t = Tabnav::Tab.new
      t.named "A Tab"
      t.links_to "/wibble"
      html = t.render(@template)
      html.should == "<li><a href=\"/wibble\">A Tab</a></li>"
    end
  end
end