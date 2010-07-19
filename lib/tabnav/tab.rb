module Tabnav
  class Tab

    def initialize(template, params, html_options = {})
      @html_options = html_options
      @params = params
      @template = template
      @name = ''
      @active = false
    end

    attr_accessor :name, :link_url, :link_options

    def named(text)
      @name = text
    end

    def links_to(url, link_options = {})
      @link_url = url
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
      partial = @html_options.delete(:tab_content_partial)
      @template.content_tag(:li, @html_options) do
        if partial
          @template.render :partial => partial, :locals => {:tab => self}
        elsif @link_url
          @template.link_to @name, @link_url, @link_options
        else
          @template.content_tag :span, @name
        end
      end
    end
  end
end