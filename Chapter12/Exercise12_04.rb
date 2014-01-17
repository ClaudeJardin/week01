#Birthday helper

def string_to_time year_str, date_str
  date_components = date_str.split(' ')
  if date_components.length != 2
    return nil
  end
  month_str = date_components[0].upcase
  day = date_components[1].to_i
  months = {"JAN"=>1, "FEB"=>2, "MAR"=>3, "APR"=>4, "MAY"=>5, "JUN"=>6, "JUL"=>7, "AUG"=>8, "SEP"=>9, "OCT"=>10, "NOV"=>11, "DEC"=>12}
  if !months.keys.include?(month_str)
    return nil
  end
  month = months[month_str]
  
  born_time = nil
  begin 
    born_time = Time.mktime(year_str.to_i, month, day)
  rescue ArgumentError
    return nil
  end
  born_time
end

def get_info filename
  members = []
  if !File.exists?(filename)
    puts 'File ' + filename + ' does not exist!'
    return nil
  else
    File.readlines(filename).each do |line|
	  tokens = line.split(',')
	  if tokens.length != 3
	    return nil
	  end
	  birthday = string_to_time(tokens[2], tokens[1])
	  if birthday == nil
	    return nil
	  end
	  members << {:name=>tokens[0], :birthday=>birthday}
	end
  end
  members  
end

def next_leap_year start_year
  while !(start_year % 400 == 0 || (start_year % 4 == 0 && start_year % 100 != 0))
    start_year = start_year + 1
  end
  start_year
end

def next_birthday birthday
  cur_time = Time.new
  if birthday.month == 2 && birthday.day == 29
    return Time.mktime(next_leap_year(cur_time.year), birthday.month, birthday.day)
  elsif cur_time.month < birthday.month || (cur_time.month == birthday.month && cur_time.day < birthday.day)
    return Time.mktime(cur_time.year, birthday.month, birthday.day)
  end
  Time.mktime(cur_time.year + 1, birthday.month, birthday.day)
end

def how_old born_time
  cur_time = Time.new
  age = cur_time.year - born_time.year
  if cur_time.month < born_time.month || (cur_time.month == born_time.month && cur_time.day < born_time.day)
	age = age - 1
  end
  age
end

members = get_info('birthday_helper.txt')
if members == nil
  puts 'Invalid content format!'
end

continue = '3'
while continue != '2'
  print 'Whose birthday are you asking for? '
  name = gets.chomp
  member = members.select {|m| m[:name] == name}.uniq
  if member.length == 0
    puts 'Name is not found!'
  else
    nb = next_birthday(member[0][:birthday])
    puts 'The next birthday of ' + name + ' is ' + nb.year.to_s + '/' + nb.month.to_s + '/' + nb.day.to_s 
	puts 'Tha age is ' + how_old(member[0][:birthday]).to_s 
  end
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