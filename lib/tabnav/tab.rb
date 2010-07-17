module Tabnav
  class Tab

    def initialize(template, html_options = {})
      @html_options = html_options
      @template = template
    end

    def named(text)
      @text = text
    end

    def links_to(url, link_options = {})
      @link = url
      @link_options = link_options
    end

    def render
      @template.content_tag(:li, @html_options) do
        if @link
          @template.link_to @text, @link, @link_options
        else
          @template.content_tag :span, @text
        end
      end
    end
  end
end