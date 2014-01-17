#One billion seconds....

cur_time = Time.new
born_date = Time.mktime(1977, 6, 27, 23, 0)
new_time = born_date + 1000000000

puts 'The exact second you were born?'
puts (cur_time - born_date).to_i.to_s + ' seconds!'
puts

puts 'The time when one billion seconds old after I was born is '
puts
puts new_time

