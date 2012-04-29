class String
  def numeric?
    true if Integer(self) rescue false
  end
end

class Array
  def sort_as_quantus_header
    char_values = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    regexp = /^P(\d+)_([[\d]|[a-zA-Z]]+)$/
    transformer = Proc.new { |item| item.chars.each.inject(0) { |collected, ch| ch = ch.numeric? ? ch : char_values.index(ch.downcase) ; collected += ch.to_i } }
    self.sort! do |x,y| 
      parts_of_x = x.scan(regexp) 
      parts_of_y = y.scan(regexp)
      
      value_for_x = "#{parts_of_x[0][0]}#{transformer.call(parts_of_x[0][1])}"
      value_for_y = "#{parts_of_y[0][0]}#{transformer.call(parts_of_y[0][1])}"
      
      value_for_x.to_i <=> value_for_y.to_i
    end
  end
end