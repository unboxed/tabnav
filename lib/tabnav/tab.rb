module Tabnav
  class Tab

    def initialize(template, params, html_options = {})
      @html_options = html_options
      @params = params
      @template = template
      @text = ''
      @active = false
    end

    def named(text)
      @text = text
    end

    def links_to(url, link_options = {})
      @link = url
      @link_options = link_options
    end

    def highlights_on(rule)
      if rule.is_a?(Hash)
        @active |= rule.with_indifferent_access.all? {|k, v| @params[k] == v.to_s}
      elsif rule.is_a?(Proc)
        @active |= rule.call
      end
    end

    def active?
      @active
    end

    def render
      @html_options[:class] = "#{@html_options[:class]} active".strip if self.active?
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