module Tabnav
  class Menu < Tab
    
    def initialize()
      super
      @tabs = []
    end

    def add_tab
      t = Tab.new
      yield(t) if block_given?
      @tabs << t
    end

    def add_sub_nav
      m = Menu.new
      yield(m) if block_given?
      @tabs << m
    end
    
    def render
      content_tag(:li) do
        content = render_contents()
        content += content_tag(:ul) do
          inner = ''
          @tabs.each do |tab|
            inner += tab.render
          end
          inner
        end
        content
      end
    end
  end
end