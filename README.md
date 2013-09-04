# Tabnav

Tabnav is a helper for generating navigation bars. It allows you to simply specify highlighting rules for each tab.

* Homepage: http://github.com/unboxed/tabnav
* Issues: http://github.com/unboxed/tabnav/issues

## Some Examples

### Simple Example

In your view:

```ruby
<%
  render_tabnav do |nav|
    nav.add_tab do |tab|
      tab.named "Home"
      tab.links_to root_path
      tab.highlights_on :controller => :home, :action => :index
    end
    nav.add_tab do |tab|
      tab.named "Froobles"
      tab.links_to froobles_path
      tab.highlights_on :controller => :froobles
    end
  end
%>
```

On `home/index` will output:

```html
<ul>
  <li class="active"><a href="/">Home</a></li>
  <li><a href="/froobles">Froobles</a></li>
</ul>
```

On any action in `FrooblesController` will output:

```html
<ul>
  <li><a href="/">Home</a></li>
  <li class="active"><a href="/froobles">Froobles</a></li>
</ul>
```

See the highlights_on method of `Tabnav::Tab` for full details of the highlighting logic.

### Nested navbars

In your view:

```ruby
<%
  render_tabnav do |nav|
    nav.add_tab do |tab|
      tab.named "Home"
      tab.links_to root_path
      tab.highlights_on :controller => :home, :action => :index
    end
    nav.add_sub_nav do |sub_nav|
      sub_nav.named "Froobles"
      sub_nav.links_to froobles_path
      sub_nav.highlights_on :controller => :froobles

      sub_nav.add_tab do |tab|
        tab.named "New Frooble"
        tab.links_to new_frooble_path
        tab.highlights_on :controller => :froobles, :action => :new
        tab.highlights_on :controller => :froobles, :action => :create
      end

      sub_nav.add_tab do |tab|
        tab.named "Search Froobles"
        tab.links_to search_froobles_path
        tab.highlights_on :controler => :froobles, :action => :search
      end
    end
  end
%>
```

On `FrooblesController#new` will output:

```html
<ul>
  <li><a href="/">Home</a></li>
  <li class="active">
    <a href="/froobles">Froobles</a>
    <ul>
      <li class="active"><a href="/froobles/new">New Frooble</a></li>
      <li><a href="/froobles/search">Search Froobles</a></li>
    </ul>
  </li>
</ul>
```

Navbars can be nested arbritarily deep.

### Options for controlling markup

View:

```ruby
<%
  render_tabnav :id => "main_navigation", :class => "clearfix" do |nav|
    nav.add_tab :class => "home_tab" do |tab|
      tab.named "Home"
      tab.links_to root_path
      tab.highlights_on :controller => :home, :action => :index
    end
    nav.add_tab :class => "heading" do |tab|
      tab.named "Froobles Heading"
      tab.highlights_on :controller => :froobles
    end
    nav.add_sub_nav :id => 'froobles' do |sub_nav|
      sub_nav.named "Froobles"

      sub_nav.add_tab do |tab|
        tab.named "All Froobles"
        tab.links_to froobles_path, :target => "_blank", :rel => "http://foo.bar/"
        tab.highlights_on :controller => :froobles, :action => :index
      end
    end
  end
%>
```

On `froobles/index` will output:

```html
<ul id="main_navigation" class="clearfix">
  <li class="home_tab"><a href="/">Home</a></li>
  <li class="heading active"><span>Froobles Heading</span></li>
  <li id="froobles">
    <span>Froobles</span>
    <ul>
      <li class="active"><a href="/froobles" target="_blank" rel="http://foo.bar/">All Froobles</a></li>
    </ul>
  </li>
</ul>
```

### Custom tab partial

It is also possible to specify a partial to be used to generate the tab contents. e.g.:

View:

```ruby
<%
  render_tabnav :html => {:id => "main_navigation", :class => "clearfix"} do |nav|
    nav.tab_content_partial = "/shared/my_custom_tab"
    nav.add_tab :html => {:class => "home_tab"} do |tab|
      tab.named "Home"
      tab.links_to root_path
      tab.highlights_on :controller => :home, :action => :index
    end
    nav.add_tab :html => {:class => "heading"} do |tab|
      tab.named "Froobles Heading"
      tab.highlights_on :controller => :froobles
    end
    nav.add_tab do |tab|
      tab.named "Froobles"
      tab.links_to froobles_path, :target => "_blank", :rel => "http://foo.bar/"
      tab.highlights_on :controller => :froobles, :action => :index
    end
  end
%>
```

In the partial, `tab` will be the `Tab` instance to be rendered.

in `/app/views/shared/_my_custom_tab.html.erb`:

```html
<div class="my_custom_class">
  <%- if tab.has_link? -%>
    <%= link_to tab.name, tab.link_url %>
  <%- else -%>
    <span><%= tab.name %></span>
  <%- end -%>
</div>
```

On `froobles/index` the output will be:

```html
<ul id="main_navigation" class="clearfix">
  <li class="home_tab"><div class="my_custom_class"><a href="/">Home</a></div></li>
  <li class="heading active"><div class="my_custom_class"><span>Froobles Heading</span></div></li>
  <li class="active"><div class="my_custom_class"><a href="/froobles">Froobles</a></div></li>
</ul>
```

## Attributions

The concept for this is based on the tabnav component from rails_widgets: http://github.com/paolodona/rails-widgets

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile, gemspec, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012 Alex Tomlins and [Unboxed Consulting](http://www.unboxedconsulting.com/). See LICENSE for details.
