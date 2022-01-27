# Improved "join"

# If we run the current game, we'll see the following prompt:

# => Choose a position to place a piece: 1, 2, 3, 4, 5, 6, 7, 8, 9

# This is ok, but we'd like for this message to read a little better. We want to separate the last item with a "or", so that it reads:

# => Choose a position to place a piece: 1, 2, 3, 4, 5, 6, 7, 8, or 9

# Currently, we're using the Array#join method, which can only insert a delimiter between the array elements, and isn't smart enough to display a joining word for the last element.

# Write a method called joinor that will produce the following result:

# joinor([1, 2])                   # => "1 or 2"
# joinor([1, 2, 3])                # => "1, 2, or 3"
# joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
# joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"

# Then, use this method in the TTT game when prompting the user to mark a square.

require 'pry'
require 'pry-byebug'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(board_arr, punct = ', ', and_or = 'or ')
  if board_arr.size >= 3 && punct != '; '
    and_or = 'and '
  elsif board_arr.size >= 2 && punct == '; '
    and_or = 'or '
  else board_arr.size == 1
    punct, and_or = ['', '']
  end

  result = board_arr.map do |selection|
   selection == board_arr.last ? (and_or + selection.to_s) : selection.to_s + punct
  end
  result.join
end


# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You play #{PLAYER_MARKER}. Computer plays #{COMPUTER_MARKER}."
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square (#{joinor(empty_squares(brd), ', ', 'and ')}):")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice.")
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

loop do
  board = initialize_board

  loop do
    display_board(board)

    player_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)

    computer_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)
  end

  display_board(board)

  if someone_won?(board)
    prompt("#{detect_winner(board)} won!")
  else
    prompt("It's a tie!")
  end

  prompt("Play again? (Y/N)")
  answer = gets.chomp.upcase
  break if answer[0] == "N"
end

prompt("Thanks for playing Tic Tac Toe. Goodbye!")
