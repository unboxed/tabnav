module Tabnav
  module Helper
    def render_tabnav(options = {})
      n = Navbar.new(options)
      yield(n) if block_given?
      concat( n.render )
    end
  end
end
