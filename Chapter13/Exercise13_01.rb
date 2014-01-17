#Put shuffle into the class Array

class Array
  def shuffle 
    shuffle = []
    recursive_shuffle(self, shuffle)
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
end

puts [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle