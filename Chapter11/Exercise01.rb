def if_file_exist filename
  File.exist?(filename)
end

Dir.chdir 'testdir/'

pic_names = Dir['C:/Users/Public/Pictures/**/*.{JPG,jpg}']
print ' What would you like to call this batch? '
batch_name = gets.chomp

puts
print ' Downloading ' +pic_names.uniq.length.to_s+' files: '

pic_number = 1
pic_names.uniq.each do |name|
  print ' .' # This is our "progress bar".
  new_name = if pic_number < 10
    batch_name + '0' + pic_number.to_s + '.jpg'
  else
    batch_name + pic_number.to_s + '.jpg'
  end
  
  if if_file_exist(new_name)
    puts
    puts 'Error! File ' + new_name + ' exists!'
    exit
  elsif if_file_exist(name)
    File.rename name, new_name
  end
  
  pic_number = pic_number + 1
end
puts 
puts ' Done, cutie!'