def prompt(text)
  puts "=> " + text.to_s
end

def initialize_deck
  deck =  %w(ace one two three four five six seven eight nine ten) +
          %w(jack queen king)
  deck.map { |card| ((card.capitalize + ' ') * 4).split }
end

def value(card)
  case card
  when 'One' then 1
  when 'Two' then 2
  when 'Three' then 3
  when 'Four' then 4
  when 'Five' then 5
  when 'Six' then 6
  when 'Seven' then 7
  when 'Eight' then 8
  when 'Nine' then 9
  when 'Ten' then 10
  when 'Jack' then 10
  when 'Queen' then 10
  when 'King' then 10
  end
end

def deal_card!(deck)
  deck.sample.empty? ? deal_card!(deck) : deck.sample.shift
end

def total(hand)
  if hand.include?('Ace')
    non_ace = hand.select { |card| card != 'Ace' && !card.nil? }
    non_ace = non_ace.map { |card| value(card) }.sum
    if hand.select { |card| card == 'Ace' && !card.nil? }.map.size < 2
      ace = hand.select { |card| card == 'Ace' && !card.nil? }
      ace = ace.map { |card| non_ace > 10 ? card = 1 : card = 11 }.sum
    else
      (hand.select { |card| card == 'Ace' && !card.nil? }.map.size).times do
        non_ace + 11 > 21 ? non_ace += 1 : non_ace += 11
      end
      ace = 0
    end
    non_ace + ace
  else
    hand.map { |cards| value(cards) }.sum
  end
end

def bust?(hand)
  total(hand) > 21
end

def hit(hand, deck)
  hand << deal_card!(deck)
end

def player_turn(player_hand, deck)
  loop do
    if bust?(player_hand)
      prompt('You have busted!')
      return
    end

    prompt('Would you like to: (1) Hit or (2) Stand?')
    answer = gets.chomp
    system 'clear'
    if answer.start_with?('1') || answer.start_with?('2')

      if answer == '1'
        hit(player_hand, deck)
        prompt('Your hand is:')
        puts player_hand
        prompt('Your total is:')
        puts total(player_hand)
      else
        'Stands'
        break
      end

    else
      prompt('Please select a valid response')
      next
    end
  end
end

def dealer_turn(dealer_hand, player_hand, deck)
  loop do
    dealer_total = total(dealer_hand)

    if bust?(dealer_hand)
      prompt('Dealer hand is:')
      puts dealer_hand
      prompt('Dealer total is:')
      puts total(dealer_hand)
      prompt('Dealer has busted!')
      return
    end

    if dealer_total < 17
      dealer_total > total(player_hand) ? break : hit(dealer_hand, deck)
    else
      break
    end
  end
end

def determine_winner(hand1, hand2)
  if bust?(hand1) == false && total(hand1) > total(hand2)
    'win'
  elsif bust?(hand2) == false && total(hand2) > total(hand1)
    'lose'
  elsif (total(hand1) == total(hand2)) || (bust?(hand1) && bust(hand2))
    'tie'
  end
end

player_chips = 2000
bet = 0

loop do
  system 'clear'
  prompt('Welcome to 21!')

  loop do
    prompt('Chips:')
    puts player_chips
    prompt('How much would you like to bet:')
    prompt('25, 50, 100')
    bet = gets.chomp.to_i
    break if [25, 50, 100].include?(bet)
    prompt('Please enter a valid response')
  end

  system 'clear'
  deck = initialize_deck
  bust = false
  player_hand = Array.new
  dealer_hand = Array.new
  player_total = 0
  dealer_total = 0
  player_hand = [deal_card!(deck)]
  dealer_hand = [deal_card!(deck)]
  player_hand << deal_card!(deck)
  dealer_hand << deal_card!(deck)

  prompt('Your hand is:')
  puts player_hand
  prompt('Your total is:')
  prompt(total(player_hand))

  prompt('The dealer is showing:')
  puts dealer_hand.min

  next if player_turn(player_hand, deck) == 'Stands'
  if bust?(player_hand)
    bust = true
    player_chips -= bet
    player_hand = Array.new
    dealer_hand = Array.new
    prompt('Thanks for playing!')
    prompt('Play again? (Y/N)')
    play_again = gets.chomp
    break if play_again.downcase.start_with?('n')
  end

  dealer_turn(dealer_hand, player_hand, deck)
  if bust?(dealer_hand)
    bust = true
    player_chips += bet
    player_hand = Array.new
    dealer_hand = Array.new
    prompt('Thanks for playing!')
    prompt('Play again? (Y/N)')
    play_again = gets.chomp
    break if play_again.downcase.start_with?('n')
  end

  system 'clear'
  dealer_total = total(dealer_hand)
  player_total = total(player_hand)
  prompt('Player hand is:')
  puts player_hand
  prompt('Player total is ' + player_total.to_s)
  prompt('Dealer hand is:')
  puts dealer_hand
  prompt('Dealer total is ' + dealer_total.to_s)

  if bust == false
    winner = determine_winner(player_hand, dealer_hand)
    if winner == 'win'
      player_chips += bet
      prompt('Player wins!')
    elsif winner == 'lose'
      player_chips -= bet
      prompt('Dealer wins!')
    elsif winner = 'tie'
      prompt("It's a tie!")
    end
  else
    next
  end

  prompt('Play again? (Y/N)')
  play_again = gets.chomp
  if play_again.downcase.start_with?('n')
    prompt('Thanks for playing 21!')
    prompt('Goodbye!')
    break
  else next
  end
end
