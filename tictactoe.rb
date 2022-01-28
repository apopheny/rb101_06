# Computer AI: Defense

# The computer currently picks a square at random. That's not very interesting. Let's make the computer defensive minded, so that if there's an immediate threat, then it will defend the 3rd square. We'll consider an "immediate threat" to be 2 squares marked by the opponent in a row. If there's no immediate threat, then it will just pick a random square.


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

def computer_defense(brd)
  choose = nil
  loop do
    if      (brd[3] == PLAYER_MARKER && brd[2] == PLAYER_MARKER) ||
            (brd[5] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
            (brd[7] == PLAYER_MARKER && brd[4] == PLAYER_MARKER)
      choose = 1
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[3] == PLAYER_MARKER && brd[1] == PLAYER_MARKER) ||
            (brd[8] == PLAYER_MARKER && brd[5] == PLAYER_MARKER)
      choose = 2
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[1] == PLAYER_MARKER && brd[2] == PLAYER_MARKER) ||
            (brd[6] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
            (brd[7] == PLAYER_MARKER && brd[5] == PLAYER_MARKER)
      choose = 3
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[5] == PLAYER_MARKER && brd[6] == PLAYER_MARKER) ||
            (brd[1] == PLAYER_MARKER && brd[7] == PLAYER_MARKER)
      choose = 4
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[4] == PLAYER_MARKER && brd[6] == PLAYER_MARKER) ||
            (brd[3] == PLAYER_MARKER && brd[7] == PLAYER_MARKER) ||
            (brd[1] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
            (brd[2] == PLAYER_MARKER && brd[8] == PLAYER_MARKER)
      choose = 5
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[4] == PLAYER_MARKER && brd[5] == PLAYER_MARKER) ||
            (brd[3] == PLAYER_MARKER && brd[9] == PLAYER_MARKER)
      choose = 6
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[8] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
            (brd[1] == PLAYER_MARKER && brd[4] == PLAYER_MARKER) ||
            (brd[3] == PLAYER_MARKER && brd[5] == PLAYER_MARKER)       
      choose = 7
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[7] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
            (brd[5] == PLAYER_MARKER && brd[2] == PLAYER_MARKER)  
      choose = 8
      empty_squares(brd).include?(choose) ? break : choose = nil
    elsif   (brd[7] == PLAYER_MARKER && brd[8] == PLAYER_MARKER) ||
            (brd[3] == PLAYER_MARKER && brd[6] == PLAYER_MARKER) ||
            (brd[1] == PLAYER_MARKER && brd[5] == PLAYER_MARKER)
      choose = 9
      empty_squares(brd).include?(choose) ? break : choose = nil
    end
    break
  end
  choose
end

def computer_places_piece!(brd)
  if computer_defense(brd).class == Integer
    square = computer_defense(brd)
  else 
    square = empty_squares(brd).sample
  end
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

player_victories = 0
computer_victories = 0

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
