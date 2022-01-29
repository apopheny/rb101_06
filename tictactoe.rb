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
    prompt("Choose a square (#{joinor(empty_squares(brd), ', ')}):")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice.")
  end
  brd[square] = PLAYER_MARKER
end

def computer_find_at_risk(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
      brd.values_at(*line).count(INITIAL_MARKER) == 1
      
      line.each do |move| 
        if brd[move] == ' ' 
            brd[move] = COMPUTER_MARKER
            return true
        end
      end   
    elsif brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
      brd.values_at(*line).count(INITIAL_MARKER) == 1
      
      line.each do |move| 
        if brd[move] == ' ' 
            brd[move] = COMPUTER_MARKER
            return true
        end
      end   

    end
  end
  false
end

def computer_places_piece!(brd)
  if computer_find_at_risk(brd) == false 
    brd[5] == ' ' ? square = 5 : square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
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

player_victories = 0
computer_victories = 0

def player_first(board)
  prompt('Player goes first.')
  loop do
    player_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)
    display_board(board)

    computer_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)
    display_board(board)
    
  end

end

def computer_first(board)
  loop do
    computer_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)
    display_board(board)
    
    player_places_piece!(board)
    break if (someone_won?(board)) || (empty_squares(board).empty?)
    display_board(board)

  end
end

loop do
  board = initialize_board
  answer = '1'
  loop do
    display_board(board)

    loop do
      prompt('Who goes first: (1) Player, (2) Computer, (3) Computer choice?')
      answer = gets.chomp
      break if %w(1 2 3).include?(answer)
      prompt("Please select a valid response.")
    end
    
    loop do
      if answer == '1'
        player_first(board)
        break
      elsif answer == '2'
        computer_first(board)
        break
      else
        answer = %w(1 2).sample
        answer == '1' ? prompt('Computer has chosen Player') : prompt('Computer has chose Computer')
      end
    end

    break
  end

  display_board(board)

  if someone_won?(board)
    detect_winner(board) == 'Player' ? player_victories += 1 : computer_victories += 1
    prompt("#{detect_winner(board)} won!")
    prompt("Player wins: #{player_victories}.")
    prompt("Computer wins: #{computer_victories}.")
  else
    prompt("It's a tie!")
    prompt("Player wins: #{player_victories}.")
    prompt("Computer wins: #{computer_victories}.")
  end

  
  if player_victories == 5 || computer_victories == 5
    prompt("#{detect_winner(board)} has won 5 games and wins the match!")
    break
  end
  
  prompt("Play again? (Y/N)")
  answer = gets.chomp.upcase
  break if answer[0] == "N"

end

prompt("Thanks for playing Tic Tac Toe. Goodbye!")
