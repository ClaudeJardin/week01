def if_file_exist filename
  File.exist?(filename)
end

def do_shuffle some_array 
  shuffle = []
  recursive_shuffle some_array, shuffle
end

def recursive_shuffle original_array, shuffle_array
  
  if original_array.length == 0
    return shuffle_array
  end
  from_index = rand(original_array.length)
  to_index = 0
  if shuffle_array.length > 0
    to_index = rand(shuffle_array.length + 1)
  end
  shuffle_array.insert(to_index, original_array[from_index])
  original_array.delete_at(from_index)
  recursive_shuffle original_array, shuffle_array
end

Dir.chdir 'testdir/'

music_names = Dir['C:/Users/Public/Music/**/*.{MP3,mp3}']
print 'Filename of playlist? '
file_name = gets.chomp
components = file_name.split('.')
if components[components.length - 1] != 'm3u'
  file_name = file_name + '.m3u'
end

music_names = do_shuffle(music_names)
File.open(file_name, 'w') do |f|
  music_names.each do |name|
    f.puts(name)
  end
end

puts 
puts 'Done!'