class String
  def numeric?
    true if Integer(self) rescue false
  end
end

class Array
  def sort_as_quantus_header
    self.sort! do |x,y| 
      x=x.delete "P" 
      y=y.delete "P"
      
      parts_of_x = x.split("_")
      parts_of_y = y.split("_")
      
      value_for_x = "#{parts_of_x[0]}#{parts_of_x[1]}"
      value_for_y = "#{parts_of_y[0]}#{parts_of_y[1]}"
            
      value_for_x += parts_of_x[2] unless parts_of_x[2].nil?
      value_for_y += parts_of_y[2] unless parts_of_y[2].nil?
      
      value_for_x += "0" if parts_of_x.length == 2
      value_for_y += "0" if parts_of_y.length == 2
        
      value_for_x.to_i <=> value_for_y.to_i
    end
  end
end