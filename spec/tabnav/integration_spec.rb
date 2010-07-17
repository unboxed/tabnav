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
  end
end