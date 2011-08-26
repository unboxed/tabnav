require 'spec_helper'

describe Tabnav::Tab do

  describe "accessors" do
    before :each do
      @tab = Tabnav::Tab.new(nil, {})
      @tab.named "A Tab"
    end

    it "should have a name accessor" do
      @tab.name.should == "A Tab"
    end

    it "should have a link_url accessor" do
      @tab.links_to "/somewhere", :target => "_blank"
      @tab.link_url.should == "/somewhere"
    end

    it "should have a link_options accessor" do
      @tab.links_to "/somewhere", :target => "_blank"
      @tab.link_options.should == {:target => "_blank"}
    end

    describe "has_link?" do
      it "should return true if a link url has been set" do
        @tab.links_to "/somewhere"
        @tab.has_link?.should == true
      end

      it "should return false otherwise" do
        @tab.has_link?.should == false
      end
    end
  end

  describe "render" do
    before :each do
      @template = ActionView::Base.new()
    end
    it "should output a li containing a span with the name if no link given" do
      t = Tabnav::Tab.new(@template, {})
      t.named "A Tab"
      html = t.render
      html.should == "<li><span>A Tab</span></li>"
    end

    it "should output a li containing a link with the name" do
      t = Tabnav::Tab.new(@template, {})
      t.named "A Tab"
      t.links_to "/wibble"
      html = t.render
      html.should == "<li><a href=\"/wibble\">A Tab</a></li>"
    end

    context "with no name given" do
      it "should output a blank tab if no link given" do
        t = Tabnav::Tab.new(@template, {})
        html = t.render
        html.should == "<li><span></span></li>"
      end
      
      it "should output an empty link" do
        t = Tabnav::Tab.new(@template, {})
        t.links_to "/wibble"
        html = t.render
        html.should == "<li><a href=\"/wibble\"></a></li>"
      end
    end

    it "should pass the options given on creation to the li" do
      @template.should_receive(:content_tag).with(:li, {:id => "my_id", :class => "my_class"}).and_return(:some_markup)
      t = Tabnav::Tab.new(@template, {}, :id => "my_id", :class => "my_class")
      t.named "A Tab"
      t.render.should == :some_markup
    end

    it "should pass the options given to the link to link_to" do
      @template.should_receive(:link_to).with("A Tab", "/wibble", {:class => "link_class", :target => "_blank"}).and_return("A Link")
      t = Tabnav::Tab.new(@template, {})
      t.named "A Tab"
      t.links_to "/wibble", :class => "link_class", :target => "_blank"
      html = t.render
      html.should == "<li>A Link</li>"
    end

    context "with a custom partial" do
      it "should render the partial, assigning the tab" do
        t = Tabnav::Tab.new(@template, {}, :tab_content_partial => 'my_partial')
        t.named "A Tab"
        @template.should_receive(:render).with(:partial => 'my_partial', :locals => {:tab => t}).and_return("Custom tab markup")
        t.render.should == "<li>Custom tab markup</li>"
      end
    end
  end

  describe "highlighting rules" do
    describe "active logic" do
      describe "params based rules" do
        it "should be active if all the optons in the rule match the params" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on "key1" => "a_value", "key2" => "another_value"
          t.should be_active
        end

        it "should not be active if only some of the values match" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on "key1" => "a_value", "key2" => "a different value"
          t.should_not be_active
        end

        it "should not be active if some of the values are missing" do
          params = {"key1" => "a_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on "key1" => "a_value", "key2" => "another_value"
          t.should_not be_active
        end

        it "should be active if any of the rules match" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on "key1" => "a_value", "key2" => "a different value"
          t.highlights_on "key1" => "a_value"
          t.highlights_on "key2" => "wibble"
          t.should be_active
        end

        it "should treat strings ans symobls at matching" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on :key1 => "a_value", :key2 => :another_value
          t.should be_active
        end

        it "should allow matching against nil" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.highlights_on :key4 => nil
          t.should be_active
        end
      end

      describe "proc based rules" do
        it "should be active if the proc returns true" do
          t = Tabnav::Tab.new(@template, {})
          t.highlights_on Proc.new { true }
          t.should be_active
        end

        it "should not be active if the proc returns false" do
          t = Tabnav::Tab.new(@template, {})
          t.highlights_on Proc.new { false }
          t.should_not be_active
        end

        it "should co-erce the result of the proc to a boolean" do
          t = Tabnav::Tab.new(@template, {})
          t.highlights_on Proc.new { "wibble" }
          t.active?.should == true
        end
      end
    end

    describe "output" do
      before :each do
        @template = ActionView::Base.new()
      end
      it "should set the class of the li to active if the tab is highlighted" do
        t = Tabnav::Tab.new(@template, {})
        t.named "A Tab"
        t.stub!(:active?).and_return(true)
        t.render.should == '<li class="active"><span>A Tab</span></li>'
      end

      it "should merge active with the other classes if highlighted" do
        t = Tabnav::Tab.new(@template, {}, {:class => "my_class"})
        t.named "A Tab"
        t.stub!(:active?).and_return(true)
        t.render.should == '<li class="my_class active"><span>A Tab</span></li>'
      end

      it "should not modify the existing html_options on the tab" do
        t = Tabnav::Tab.new(@template, {}, {:class => "my_class"})
        t.named "A Tab"
        t.stub!(:active?).and_return(true)
        t.render
        t.stub!(:active?).and_return(false)
        t.render.should == '<li class="my_class"><span>A Tab</span></li>'
      end
    end
  end
end
