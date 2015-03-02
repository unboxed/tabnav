module Tabnav
  class Navbar < Tab
    def initialize(template, params, html_options = {}) # :nodoc:
      @top_level = html_options.delete(:top_level)
      @container_options = html_options.delete(:container_html)
      super
      @tabs = []
      @tab_content_partial = @partial
    end

    # Optionally specifies a partial to be used to render the tab content.
    attr_writer :tab_content_partial

    # Creates a Tab and adds it to the navbar.
    #
    # +options+ is an optional hash of options which will be used to create the +li+ for the tab.
    #
    # yields the created Tab
    def add_tab(options = {}, &block)
      add_item(Tab, options, &block)
    end

    # Creates a sub Navbar and adds it to the navbar.
    #
    # +options+ is an optional hash of options which will be used to create the +li+ containing the sub navbar.
    #
    # yields the created Navbar
    def add_sub_nav(options = {}, &block)
      add_item(Navbar, options, &block)
    end

    def render_navbar # :nodoc:
      return ''.html_safe if @tabs.empty?
      options = @top_level ? @html_options : @container_options
      @template.content_tag :ul, options do
        contents = ''.html_safe
        @tabs.each do |tab|
          contents << tab.render
        end
        contents
      end
    end

    private

    def add_item(klass, options)
      options[:tab_content_partial] = @tab_content_partial if @tab_content_partial
      i = klass.new(@template, @params, options)
      yield i
      @tabs << i
    end

    def render_tab
      super + render_navbar
    end
  end
end
