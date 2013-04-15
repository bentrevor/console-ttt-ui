class ConsoleIO
  def self.gets
    $stdin.gets
  end

  def self.make_printable(board)
    printable_board = "   "
    (0..2).map { |n| printable_board << char_or_empty(board, n) }
    printable_board << "\n   "
    (3..5).map { |n| printable_board << char_or_empty(board, n) }
    printable_board << "\n   "
    (6..8).map { |n| printable_board << char_or_empty(board, n) }
    printable_board << "\n\n"
    printable_board
  end

  def self.show(board, game)
    Kernel.system "clear"
    show_instructions
    show_divider
    show_whose_turn board, game
    puts make_printable board
    show_divider
    sleep 2 if game.other_player.class.to_s == "ComputerPlayer"
  end

  def self.menu_string
    ["(1)human v human",
     "(2)computer v computer",
     "(3)human v computer",
     "(4)computer v human",
     "(5)quit"].join "\n"
  end

  def self.show_menu
    puts menu_string
  end

  def self.show_game_over_message(board, game)
    if board.check_winner? 'x'
      puts 'X wins!'
    elsif board.check_winner? 'o'
      puts 'O wins!'
    else
      puts "Game over!"
    end

    game.restart
  end

  def self.show_unavailable_position_message
    puts "That position is already taken."
  end

  def self.show_incorrect_player_message
    puts "It's not your turn."
  end

  def self.show_invalid_position_message
    puts "Pick an integer between 0 and 8."
  end

  def self.show_restart_message
    puts "\n\nChoose the players for the new game:"
  end

  private
  def self.char_or_empty(board, position)
    if board.spaces[position].nil?
      '.'
    else
      board.spaces[position]
    end
  end

  def self.show_instructions
    puts %Q[
Instructions: Input a number and press Enter.
              To restart, input 'restart' and press Enter.

Legend:
   012
   345
   678

    ]
  end

  def self.show_divider
    puts '========='
  end

  def self.show_whose_turn(board, game)
    puts game.other_player.class.to_s.sub 'Player', ''
    puts "#{board.current_char.upcase}'s turn\n\n"
  end
end
