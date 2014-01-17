
require_relative 'blackjack_player'
require_relative 'blackjack_game'
require_relative 'blackjack_tools'

#Show title
srand
system('cls')
show_text_banner('Welcome to Blackjack', 1)

#User input for initialize
print 'Your Name: '
name = gets.chomp.downcase.capitalize

print 'Players: '
number_of_player = gets.chomp.to_i
number_of_player = (number_of_player < 2)? 2 : number_of_player

puts 'Decks (1~8): 4'
#number_of_decks = gets.chomp.to_i
number_of_decks = 4 #(number_of_decks < 1)? 1 : ((number_of_decks > 8)? 8 : number_of_decks)

puts 'Betting Chips: 1000'
#number_chips = gets.chomp.to_i
number_chips = 1000 #(number_chips < 100)? 100 : ((number_chips > 10000)? 10000 : number_chips)

puts 'Betting Odds: 1.5'
odds = 1.5

#Player Initialization
players = player_init(number_of_player)
i = 0
while i < players.length
  if i == 0
    players[0][:name] = name
    players[0][:is_human] = 1
  else
    players[i][:name] = 'COM' + i.to_s
  end
  players[i][:total_chips] = number_chips
  set_winning_rate_of(players[i], 1, players.length)
  i = i + 1
end
set_betting_pattern_of(players[1], 1)

#Card Initialization
cards = card_shuffle(card_init(number_of_decks))

dealer = number_of_player - 1 
game = game_init(players, cards, dealer, odds, number_of_decks)
while if_continue_for(game)
  game_start_with(game)

  show_text_banner('', 1)
  print 'Do you want to try again? [Y]es/[N]o: '
  answer = gets.chomp
  if answer.downcase != 'y'
    quit_game_for(game)
  else
    restart(game)	
  end
end
