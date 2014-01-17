def card_init number_of_decks
  suits = [0, 1, 2, 3]
  cards = []
  inx = 0
  amount_cards = number_of_decks * 52
  while inx < amount_cards 
      cards << {suit: inx / 13, face: inx % 13 + 1, visible: 0}
	  inx = inx + 1
  end
  cards
end

def face_of_card card
  if card == nil
    return ''
  end
  face = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  return (card[:visible] == 1)? face[card[:face] - 1] : '?'
end

def get_card_string_for cards
  if cards == nil
    return ''
  end
  result = ''
  i = 0
  while i < cards.length
    result = result + face_of_card(cards[i])
	if i < cards.length - 1
	  result = result + ', '
	end
	i = i + 1
  end
  result
end

#Recursive Shuffle

def card_shuffle some_array 
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