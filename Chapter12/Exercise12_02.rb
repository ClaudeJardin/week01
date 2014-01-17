continue = '3'
while continue != '2'
  print 'What year were you born in? '
  year = gets.chomp.to_i
  print 'What month were you born in? '
  month = gets.chomp.to_i
  print 'What day were you born in? '
  day = gets.chomp.to_i
  
  begin 
    born_time = Time.mktime(year, month, day)
	cur_time = Time.new
	how_old = cur_time.year - born_time.year
	if cur_time.month < born_time.month || (cur_time.month == born_time.month && cur_time.day < born_time.day)
	  how_old = how_old - 1
	end
	puts
	print "Guess how old you are? "
	answer = gets.chomp.to_i
	if answer == how_old
	  print "SPANK! Happy birthday for " + answer.to_s + " years old!"
	elsif
	  print "Wrong! It should be " + how_old.to_s + " years old!"   
	end
  rescue ArgumentError
    puts "Error! The time " + year.to_s + "/" + month.to_s + "/" + day.to_s + " is not valid!"
  end
  puts
  puts
  continue = '3'  
  while !['1', '2'].include?(continue)
    print 'Continue? 1)Yes 2)No? '
	continue = gets.chomp
    if !['1', '2'].include?(continue) 
       puts 'Error! '
       next
    end
  end 
end