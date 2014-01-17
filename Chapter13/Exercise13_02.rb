#Expansion of the class Integer

class Integer
  def factorial
    if self < 0
	  return 0
	elsif self <= 1
	  return 1
	end
	product = 1
	self.times do |i|
	  product = product * (i + 1)
	end
	product
  end
  
  def to_roman
    old_roman_numeral(self)
  end
  def old_roman_numeral integer 
    n = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    romans = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
    result = ''
    i = 0
  
    if integer < 4
      return 'I' * integer
    end
    while i < n.length && integer > 0
      r = integer / n[i]
      if r > 0
        prefix = ''
        if r > 1
          prefix = old_roman_numeral (r - 1) * n[i]
        end
      
        middle = ''
        if i < n.length - 1
          middle = romans[i]
        end
      
        postfix = old_roman_numeral integer % n[i]
      
        return prefix + middle + postfix
      end
      integer = integer % n[i]
      i = i + 1
    end
    ''
  end
end

puts 5.factorial
puts 1999.to_roman
puts 49.to_roman