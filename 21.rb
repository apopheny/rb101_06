# Logical Steps

# initialize deck


# deal one card from deck to player, removing card
# deal one card from deck to dealer, removing card
# deal one card from deck to player, removing card
# deal one card from deck to dealer, removing card
# reveal player hand to player, summing total *1
# reveal only one card from dealer hand unless dealer value == 21
# unless player hand == 21, ask player if they'd like to hit until total >= 21 or player says no
#   if player hand > 21, player loss
# unless dealer hand == 21, dealer hits until hand >= 17
#   if dealer hand > 21, dealer loss
# if player hand > dealer hand, else dealer wins unless equal
#   play again?
require 'pry'
def prompt(text)
  puts "=> #{text}"
end

def initialize_deck
  %w(ace one two three four five six seven eight nine ten jack queen king).map { |card| ((card.capitalize + ' ') * 4).split }
end

def value(card, total = 0)
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
  when 'Ace'
    total >= 21 ? 1 : 11
  end
end

def deal_card!(deck)
  deck.sample.empty? ? deal_card!(deck) : deck.sample.shift
end

def total(hand)
  if hand.include?('Ace')
    non_ace = hand.select { |card| card != 'Ace' && card != nil }.map { |card| value(card) }.sum
    ace = hand.select { |card| card == 'Ace' && card != nil }.map { |card| non_ace > 10 ? card = 1 : card = 11 }.sum
    non_ace + ace
  else
    hand.map { |cards| value(cards) }.sum
  end
end

def bust?(hand)
  total(hand) > 21 ? true : false
end

def hit(hand, deck)
  hand << deal_card!(deck)
  system 'clear'
end

def player_turn(player_hand, dealer_hand, deck)
  loop do
    prompt('Your hand is:')
    puts player_hand
    prompt('Your total is:')
    prompt(total(player_hand))
    prompt('The dealer is showing:')
    puts dealer_hand.sort[0]
    prompt('Would you like to: (1) Hit or (2) Stand?')
    answer = gets.chomp
    if answer == '1'
        hit(player_hand, deck)
    elsif answer == '2' || bust?(player_hand)
      break
    else
      prompt 'Please select a valid response.'
    end
  end
end

deck = initialize_deck

player_total = [0]
dealer_total = [0]

player_hand = [deal_card!(deck)]
dealer_hand = [deal_card!(deck)]
player_hand << deal_card!(deck)
dealer_hand << deal_card!(deck)

player_total = total(player_hand)
dealer_total = total(dealer_hand)

prompt('Welcome to 21!')

answer = ''

loop do
  player_turn(player_hand, dealer_hand, deck)
end
