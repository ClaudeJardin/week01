
require_relative 'blackjack_card'
require_relative 'blackjack_player'

def game_init game_players, game_cards, game_dealer, game_odds, game_decks
  game = {players:game_players, 
          cards:game_cards, 
		  dealer:game_dealer, 
		  odds:game_odds, 
		  status:'Continue', 
		  rounds:1,
		  decks: game_decks  #how many decks used
		  } 
  return game
end

def if_continue_for game
  if game[:status] == 'Continue'
    return true
  end
  false
end

def quit_game_for game
  game[:status] = 'Quit'
end

def restart game
  puts ''
  print 'OK! Game Restart'
  thinking(1)
  puts ''
  system('cls')
  game[:rounds] = game[:rounds] + 1
end

def game_start_with game  
  
  players = game[:players]
  cards = card_decks_from(game)
  dealer = game[:dealer]
  
  show_text_banner('Round ' + game[:rounds].to_s, 1)
  show_table_of(players, dealer)
  
  new_game_for(players)
  turn = (dealer + 1) % players.length
  #Betting
  show_text_banner('Place Chips', 1)
  while turn != dealer
    player = players[turn]
	if if_bankrupt(player)
	  turn = (turn + 1) % players.length
	  next
	end
	print player[:name] + ': '
	bet = 0
	if player[:is_human] == 1
	  bet = gets.chomp.to_i
	  bet = (bet > player[:total_chips])? player[:total_chips] : bet 
	else
	  thinking(2)
	  bet = computer_bet_for(player, game[:odds])
	  puts bet.to_s
	end
	player[:bet] = bet
	turn = (turn + 1) % players.length
  end
  puts ''
  
  #Initial dealing
  show_text_banner('Initial Dealing', 1)
  players.each do |player|
    if !if_bankrupt(player)
	  visible = (player == players[dealer])? 0 : 1
      card_dealing(cards, player, visible)
	  card_dealing(cards, player, visible)
	end
  end
  
  game_result_for(players, dealer, game[:odds])
  puts ''
  
  #Dealing card
  turn = (dealer + 1) % players.length
  while turn != dealer
	player = players[turn]
	if if_bankrupt(player)
	  turn = (turn + 1) % players.length
	  next
	end
	
	if player[:state] == 'normal'
      if player[:is_human] == 1
	    show_text_banner('Your Turn', 1)
	  else
	    show_text_banner(player[:name] + '\'s Turn', 1)
	  end
	end
	
    answer = 0
	while answer != 2
	  if player[:state] == 'normal'
	    status_string = show_result_for(player, 1)
		option_string = '[H]it/[S]tay: '
	    print option_string
		
	    if player[:is_human] == 1 
	      answer = hit_or_stay
	    else
		  thinking(2)    #pretending that the computer is thinking
	      answer = computer_hit_or_stay_for(player)
		  puts ((answer == 1)? 'Hit' : 'Stay')
	    end
	    if answer == 1
	      card_dealing(cards, player, 1)
		  sum = player[:points]
		  
		  if sum == 21 || sum > 21
		      show_result_for(player, 1)
			  puts ''
		  end
	    end
	  else
	    answer = 2
      end		
	end
	puts ''
	turn = (turn + 1) % players.length
  end
  
  #dealer hit
  show_cards_of(players[dealer])
  if players[dealer][:state] == 'normal' && players[dealer][:points] < 17
    show_text_banner('Dealer\'s Turn', 1)
    sum = compute_sum_for(players[dealer])
    show_result_for(players[dealer], 1)
    while sum < 17
	  print 'Hit'
	  puts ''
      sleep(2)
      card_dealing(cards, players[dealer], 1)
	  sum = compute_sum_for(players[dealer])
	  show_result_for(players[dealer], 1)
	  if players[dealer][:state] != 'normal' || sum >= 17
	    puts ''
	  end
    end
    puts ''
  end
  
  #competition
  players = player_compete(players, dealer)

  #output result
  show_text_banner('Result', 1)
  game_result_for(players, dealer, game[:odds])
end 

#If the number of cards is less than half, 
def card_decks_from game
  if game[:cards].length < game[:decks] * 26
    game[:cards] = card_shuffle(card_init(game[:decks]))
  end
  game[:cards]
end

def card_dealing cards, player, visible
  cards[0][:visible] = visible
  player[:cards].push(cards[0])
  player[:points] = compute_sum_for(player)
  cards.delete_at(0)
  update_state_for(player)
end

def hit_or_stay
  answer = 0
  answer = gets.chomp.downcase
  if answer == 'h'
    return 1
  end
  2
end



def game_result_for players, dealer, odds
  puts 'Dealer:'
  show_result_for(players[dealer], 1) 
  puts ''
  puts ''
  puts 'Player:'
  i = 0
  while i < players.length
    if i != dealer
	  if if_bankrupt(players[i])
	    i = i + 1
	    next
	  end
	  result_update_to(players[i], players[dealer], odds)
	  show_result_for(players[i], 1)
	  print ' '
	  if players[i][:state] == 'won'
	    print '$' + players[i][:total_chips].to_s.rjust(4) + ' (+' + (players[i][:bet].to_f * odds).to_i.to_s.rjust(4) + ')'
	  elsif players[i][:state] == 'lost'
	    print '$' + players[i][:total_chips].to_s.rjust(4) + ' (-' + players[i][:bet].to_s.rjust(4) + ')'
	  end
	  puts ''
	  
	end
    i = i + 1 
  end 
  puts ''  
end

def show_result_for player, status_visible
  flag = invisible_card_of(player)
  status_string = (player[:state] == 'normal' || status_visible == 0 || flag == true)? '' : player[:state].capitalize.ljust(4)
  point_string = (flag == true)? '?' : player[:points].to_s
  print_string = (player[:name] + ': ').ljust(10) + get_card_string_for(player[:cards]).ljust(25) + 'Points=' + point_string.to_s.ljust(11) + '  ' + status_string
  print print_string
  print_string  
 end