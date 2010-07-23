module NavLogic
  module Helper
    def render_tabnav(options = {})
      n = Navbar.new(self, params, options)
      yield(n)
      concat( n.render )
    end
  end
end
