require 'spec_helper'

describe Tabnav::Helper do
  include Tabnav::Helper

  describe "render_tabnav" do
    before :each do
      @navbar = Tabnav::Navbar.new()
      Tabnav::Navbar.stub!(:new).and_return(@navbar)
      @navbar.stub!(:render).and_return('')
      self.stub!(:concat)
    end

    it "should create a new Navbar with the options passed" do
      Tabnav::Navbar.should_receive(:new).with({:foo => 'bar'}).and_return(@navbar)
      render_tabnav :foo => 'bar' do |n|
      end
    end

    it "should yield the navbar to the block" do
      yielded_navbar = nil
      render_tabnav :foo => 'bar' do |n|
        yielded_navbar = n
      end
      yielded_navbar.should == @navbar
    end

    it "should not blow up if no block given" do
      lambda do
        render_tabnav :foo => 'bar'
      end.should_not raise_error
    end

    it "should concat the results of calling render on the navbar" do
      @navbar.should_receive(:render).and_return("Some Navbar Markup")
      self.should_receive(:concat).with("Some Navbar Markup")
      render_tabnav
    end
  end
end
