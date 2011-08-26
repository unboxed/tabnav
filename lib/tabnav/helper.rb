module Tabnav
  module Helper

    # This is the main method to be used in your views.
    # It creates and yields a new instance of Navbar.
    #
    # +options+ is an optional hash of options that are passed to the navbar, and 
    # and used to create the +ul+.
    #
    # Finally, this renders the navbar, and concats the result into the view.
    def render_tabnav(options = {})
      n = Navbar.new(self, params, options)
      yield(n)
      concat( n.render_navbar )
      nil
    end
  end
end
