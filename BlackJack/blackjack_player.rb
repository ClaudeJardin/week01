
def player_init number
  i = 0
  players = []
  number = number > 6 ? 6 : (number < 2 ? 2 : number)
  
  while i < number
    players.push({name: '',     
	             is_human: 0,      #human player? 0 denotes no; otherwise, yes
				 state: 'normal',  #player state
                 cards: [],        #cards that the player holds, a set for storing card element
				 points: 0,        #points
				 bet: 0,
                 total_chips: 0,   #betting_chips
				 hit_stay: 0,
				 bet_pattern: 0,
				 history: [],
				 total_win: 1,     #no. of rounds the player won
				 total_round: 2,   #total rounds players game
                 rate: 0.5         #winning rate			  
			    })
	i = i + 1
  end
  players
end

#Restart a new game, and then clear the status for players
def new_game_for players
  players.each do |player|
    player[:state] = 'normal'
	player[:cards] = []
	player[:points] = 0
	player[:bet] = 0
  end
end

#Set and get function for player's status
def set_status_for player, status
  if player == nil
    return nil
  end	
  player[:status] = status
  player
end

def get_status_of player
  if player == nil
    return ''
  end
  player[:status]
end

def set_betting_pattern_of player, pattern
  if player != nil && pattern >= 0
    player[:bet_pattern] = pattern
  end
end

def set_winning_rate_of player, win_round, total_round
  if player != nil && total_round > 0
    player[:total_win] = win_round
	player[:total_round] = total_round
	player[:rate] = win_round.to_f / total_round.to_f
  end
end

def computer_bet_for player, odds
  bet = 0
  if player[:bet_pattern] == 0
    bet = 1 + rand(player[:total_chips])
  elsif player[:bet_pattern] == 1
    bet = (player[:total_chips].to_f * ((odds * 0.5 - 0.5) / odds)).to_i
	bet = (bet < 0 && player[:total_chips] > 0)? 1 : bet
  end
  bet
end

def computer_hit_or_stay_for player
  answer = 2
  if player[:hit_stay] == 0
    sum = compute_sum_for(player)
    answer = 2
    if sum < 21
      answer = rand(2) + 1
    end
  end
  answer
end

#Show a table of players' state
def show_table_of players, dealer
  hit_stay = ['RANDOM']
  bet_pattern = ['RANDOM', 'KELLY']
  
  puts 'Dealer: ' + players[dealer][:name] + '($' + players[dealer][:total_chips].to_s + ')'
  puts ''
  
  turn = (dealer + 1) % players.length
  
  name_width = 10
  hit_stay_width = 15
  bet_pattern_width = 20
  chips_width = 15
  rate_width = 15
  puts 'Name'.ljust(name_width) + 'Hit/Stay'.rjust(hit_stay_width) + 'Bet Pattern'.rjust(bet_pattern_width) + 'Chips'.rjust(chips_width) + 'Rate'.rjust(rate_width)
  while turn != dealer
    player = players[turn]
	name = player[:name] + ((if_bankrupt(player))? ' (X)' : '')
	hit_stay_string = (player[:is_human] == 1)? 'x' : hit_stay[player[:hit_stay]]
	bet_pattern_string = (player[:is_human] == 1)? 'x' : bet_pattern[player[:bet_pattern]]
	chips_string = player[:total_chips].to_s
	rate_string = (player[:rate] * 100.0).round(2).to_s + '%' 
	
	puts name.ljust(name_width) + hit_stay_string.rjust(hit_stay_width) + bet_pattern_string.rjust(bet_pattern_width) + chips_string.rjust(chips_width) + rate_string.rjust(rate_width)
	
	turn = (turn + 1) % players.length
  end
  puts ''
end

def if_bankrupt player
  if player[:total_chips] <= 0
    return true
  end
  false
end

#Show cards or not?
def show_cards_of player
  if player == nil
    return
  end
  player[:cards].each do |card|
    card[:visible] = 1
  end
end

def invisible_card_of player
  i = 0
  while i < player[:cards].length
    card = player[:cards][i]
    if card[:visible] == 0
	  return true
	end
	i = i + 1
  end
  false
end

#Compute the sums of cards
def compute_sum_for player
  if player == nil || player[:cards] == nil || player[:cards].length == 0
    return 0
  end
  
  #Compute initial points
  sum = 0
  i = 0
  
  while i < player[:cards].length
    card = player[:cards][i]
    sum = sum + (card[:face] > 10 ? 10 : ((card[:face] == 1)? 11 : card[:face]))
	i = i + 1
  end
  
  #Fix the sum if possible, when the points is larger than 21
  j = player[:cards].length - 1
  while sum > 21 && j >= 0
	card = player[:cards][j]
	if card[:face] == 1  #There is an Ace
	  sum = sum - 11 + 1
	end
	j = j - 1
  end
	
  sum
end

#Update player's state
def update_state_for player
  sum = compute_sum_for(player)
  if sum > 21
    player[:state] = 'busted'
  elsif sum == 21
    player[:state] = 'blackjack'
  end
  player
end

#update result to player and dealer
def result_update_to player, dealer_player, odds
  if player[:state] == 'won' 
    amount = (player[:bet].to_f * odds).to_i
    player[:total_chips] = player[:total_chips] + amount
	dealer_player[:total_chips] = dealer_player[:total_chips] - amount
	player[:total_win] = player[:total_win] + 1
	player[:history].push('won')
  elsif player[:state] == 'lost'
    player[:total_chips] = player[:total_chips] - player[:bet]
	dealer_player[:total_chips] = dealer_player[:total_chips] + player[:bet]
    player[:history].push('lost')
  else
    player[:history].push('push')
  end
  player[:total_round] = (player[:state] == 'won' || player[:state] == 'lost')? player[:total_round] + 1 : player[:total_round]
  player[:rate] = (player[:total_round] > 0)? player[:total_win].to_f / player[:total_round].to_f : player[:rate]
end

#Number of competitors
def number_of_competitors_in players
  number = 0
  players.each do |player|
    if player[:state] == 'normal'
	  number = number + 1
	end
  end
  number
end

#competition
def player_compete players, dealer
  dealer_player = players[dealer]
  players.each do |player|
	if player != dealer_player
	  if dealer_player[:state] == 'blackjack'
	    player[:state] = (player[:state] == 'blackjack')? 'push' : 'lost'
	  elsif dealer_player[:state] == 'busted'
	    player[:state] = (player[:state] == 'busted')? 'lost' : 'won'
	  elsif player[:state] == 'busted'
	    player[:state] = 'lost'
	  else
	    player[:state] = (player[:points] > dealer_player[:points])? 'won' : ((player[:points] == dealer_player[:points])? 'push' : 'lost')
      end	  
	end
  end
end