module Tabnav
  class Navbar
    def initialize(template, params, options = {})
      @template = template
      @params = params
      @html_options = options
      @tabs = []
    end

    def add_tab(options = {})
      t = Tab.new(@template, @params, options)
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
