module Tabnav
  class Navbar
    def initialize(template, params, options = {}) # :nodoc:
      @template = template
      @params = params
      @html_options = options
      @tabs = []
    end

    # Optionally specifies a partial to be used to render the tab content.
    attr_writer :tab_content_partial

    # Creates a Tab and adds it to the navbar.
    #
    # +options+ is an optional hash of options which will be used to create the +li+ for the tab.
    #
    # yields the created Tab
    def add_tab(options = {})
      options[:tab_content_partial] = @tab_content_partial if @tab_content_partial
      t = Tab.new(@template, @params, options)
      yield t
      @tabs << t
    end

    def add_sub_nav(options = {}, &block)
      options[:tab_content_partial] = @tab_content_partial if @tab_content_partial
      sn = Navbar.new(@template, @params, options)
      yield sn
      @tabs << sn
    end

    def render_navbar # :nodoc:
      return '' if @tabs.empty?
      @template.content_tag :ul, @html_options do
        contents = ''.html_safe
        @tabs.each do |tab|
          contents << tab.render
        end
        contents
      end
    end
  end
end
