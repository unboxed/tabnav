module Tabnav
  module Helper
    
    
    def render_tabnav do
      raise "Must pass a block" unless block_given?
      
      m = Menu.new()
      yield(n)
      
      concat( n.render )
    end
  end
end