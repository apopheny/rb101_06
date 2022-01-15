require 'pry'
require 'pry-byebug'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
def prompt(msg)
  puts "=> #{msg}"
end
  
def display_board(brd)
  puts ""
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

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

board = initialize_board
display_board(board)

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square (#{empty_squares(brd).join(', ')}):")
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
  winning_lines = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
    [1, 5, 9], [3, 5, 7]             # diagonals
  ]
  winning_lines.each do |line|
    if brd[line] == PLAYER_MARKER
      return 'Player'
    elsif brd[line] == COMPUTER_MARKER
      return 'Computer'
    end
    nil
  end
end

loop do
  break if someone_won?(board) || empty_squares(board).empty?
  player_places_piece!(board)
  display_board(board)
  computer_places_piece!(board)
  display_board(board)
end

if someone_won?(board)
  prompt("#{detect_winner(board)} won!")
else
  prompt("It's a tie!")
end

p board.inspect
display_board(board)
