module Tabnav
  class Tab

    def initialize(template, params, html_options = {}) # :nodoc:
      @html_options = html_options
      @params = params
      @template = template
      @name = ''
      @active = false
    end

    # The name of this tab
    attr_accessor :name

    # The link destination
    attr_accessor :link_url

    # The link options (if any)
    attr_accessor :link_options

    # Returns true if this tab has had a link set on it.
    def has_link?
      !! @link_url
    end

    # Sets the name of this tab.  This will be used as the contents of the link or span
    def named(text)
      @name = text
    end

    # Sets the link destination.
    #
    # +link_options+ is an option hash of options that will be
    # passed through to the link_to call.
    def links_to(url, link_options = {})
      @link_url = url
      @link_options = link_options
    end

    # Adds a highlight condition to this tab.  +rule+ can be one of the following:
    #
    # * A Hash: The tab will be highlighted if all the values in the given hash match the
    #   params hash (strings and symbols are treated as equivelent).
    # * A Proc: The proc will be called, and the tab will be highlighted if it returns true.
    #
    # If multiple highlight conditions are given, the tab will be highlighted if any of them match.
    def highlights_on(rule)
      if rule.is_a?(Hash)
        @active |= rule.with_indifferent_access.all? {|k, v| @params[k].to_s == v.to_s}
      elsif rule.is_a?(Proc)
        @active |= rule.call
      end
    end

    # Returns +true+ of this tab is highlighted.
    def active?
      @active
    end

    def render # :nodoc:
      # @link_options[:class] = "#{@link_options[:class]} active".strip if self.active?
      @link_options[:class] = self.active? ? "#{@html_options[:class]} active".strip : @html_options[:class]
      
      partial = @html_options.delete(:tab_content_partial)
      
      # @template.content_tag(:li, @html_options) do
      #   if partial
      #     @template.render :partial => partial, :locals => {:tab => self}
      #   elsif has_link?
      #     @template.link_to @name, @link_url, @link_options
      #   else
      #     @template.content_tag :span, @name
      #   end
      # end
      if partial
        @template.render :partial => partial, :locals => {:tab => self}
      elsif has_link?
        @template.link_to @name, @link_url, @link_options
      else
        @template.content_tag :span, @name
      end
    
    end
  end
end