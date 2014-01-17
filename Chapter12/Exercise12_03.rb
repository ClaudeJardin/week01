#Roman_to_integer
def roman_to_integer str
  start = 0
  romans = {'M'=>1000, 'CM'=>900, 'D'=>500, 'CD'=>400, 'C'=>100, 'XC'=>90, 'L'=>50, 'XL'=>40, 'X'=>10, 'IX'=>9, 'V'=>5, 'IV'=>4, 'I'=>1}
  
  sum = 0
  while start < str.length - 1
    if romans.keys.include?(str[start, 2])
	  sum += romans[str[start, 2]]
	  start = start + 2
	elsif romans.keys.include?(str[start, 1])
	  sum += romans[str[start, 1]]
	  start = start + 1
	else
	  puts start.to_s
	  return -1
	end
  end
  if start < str.length 
    if romans.keys.include?(str[start, 1])
      sum += romans[str[start, 1]]
    else
      return -1
    end
  end
  sum
end


while true
  puts 'Input integer (\'-1\' to quit): '
  input = gets.chomp.upcase
  if input == '-1'
    exit
  else
    result = roman_to_integer(input)
	if result == -1
	  puts 'Invalid input!'
	else
	  puts 'Integer => ' + result.to_s
	end
	puts
  end
end
