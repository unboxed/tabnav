module Tabnav
  module Helper
    def render_tabnav(options = {})
      n = Navbar.new(self, options)
      yield(n)
      concat( n.render )
    end
  end
end
