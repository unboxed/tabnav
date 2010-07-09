module Tabnav
  class Tab
    def initialize
      
    end
    
    def render
      content_tag(:li, render_contents )
    end
    
    def render_contents
      if self.active?
        link_to name, url
      else
        "<span>#{name}</span>"
      end
    end
  end
end