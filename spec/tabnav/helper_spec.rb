require 'spec_helper'

describe Tabnav::Helper, :type => :helper do

  describe "render_tabnav" do
    before :each do
      # helper is an instance of a subclass of ActionView::Base
      @template = helper
      @navbar = Tabnav::Navbar.new(@template, {})
      Tabnav::Navbar.stub!(:new).and_return(@navbar)
      helper.output_buffer = ''
    end
    it "should create a new navbar with the template and params and yield it to the block" do
      params[:foo] = "bar"
      Tabnav::Navbar.should_receive(:new).with(@template, {"foo" => "bar"}, {}).and_return(@navbar)
      helper.render_tabnav do |n|
        n.should == @navbar
      end
    end

    it "should create a new navbar with any passed options" do
      Tabnav::Navbar.should_receive(:new).with(@template, {}, {:class => "my_class", :id => "my_id"}).and_return(@navbar)
      helper.render_tabnav :class => "my_class", :id => "my_id" do |n|
        n.should == @navbar
      end
    end

    it "should concat the results of calling render on the navbar" do
      @navbar.should_receive(:render).and_return("Some Navbar Markup")
      helper.render_tabnav {|n| }
      helper.output_buffer.should == "Some Navbar Markup"
    end
  end

  it "should be included in ActionController::Base's helpers" do
    ActionController::Base.helpers.should be_a(Tabnav::Helper)
  end
end
