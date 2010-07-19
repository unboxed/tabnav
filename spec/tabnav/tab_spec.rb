require 'spec_helper'

describe Tabnav::Tab do

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

    describe "highlighting rules" do
      describe "active logic" do
        it "should be active if all the optons in the rule match the params" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.named "A Tab"
          t.highlights_on "key1" => "a_value", "key2" => "another_value"
          t.should be_active
        end

        it "should not be active if only some of the values match" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.named "A Tab"
          t.highlights_on "key1" => "a_value", "key2" => "a different value"
          t.should_not be_active
        end

        it "should not be active if some of the values are missing" do
          params = {"key1" => "a_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.named "A Tab"
          t.highlights_on "key1" => "a_value", "key2" => "another_value"
          t.should_not be_active
        end

        it "should be active if any of the rules match" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.named "A Tab"
          t.highlights_on "key1" => "a_value", "key2" => "a different value"
          t.highlights_on "key1" => "a_value"
          t.highlights_on "key2" => "wibble"
          t.should be_active
        end

        it "should treat strings ans symobls at matching" do
          params = {"key1" => "a_value", "key2" => "another_value", "key3" => "something else"}
          t = Tabnav::Tab.new(@template, params)
          t.named "A Tab"
          t.highlights_on :key1 => "a_value", :key2 => :another_value
          t.should be_active
        end
      end

      describe "output" do
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
      end
    end
  end
end
