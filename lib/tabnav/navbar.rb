module Tabnav
  class Navbar
    def initialize(template, options = {})
      @template = template
      @html_options = options
      @tabs = []
    end

    def add_tab(options = {})
      t = Tab.new(@template, options)
      yield t
      @tabs << t
    end

    def render
      return '' if @tabs.empty?
      @template.content_tag :ul, @html_options do
        contents = ''
        @tabs.each do |tab|
          contents += tab.render
        end
        contents
      end
    end
  end
end
