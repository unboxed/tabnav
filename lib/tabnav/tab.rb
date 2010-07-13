module Tabnav
  class Tab

    def named(text)
      @text = text
    end

    def links_to(url)
      @link = url
    end

    def render(template)
      template.content_tag(:li) do
        if @link
          template.link_to @text, @link
        else
          template.content_tag :span, @text
        end
      end
    end
  end
end