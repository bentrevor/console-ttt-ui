require 'human_player'
require 'user_prompter'
require 'console_io'

class Game
  attr_accessor :io, :board, :current_player, :other_player

  def initialize(io = ConsoleIO, board = Board.new)
    self.io = io
    self.board = board
    self.board.add_observer self
  end

  def init_players(choice=nil)
    choice ||= UserPrompter.get_menu_choice io
    set_players HumanPlayer, HumanPlayer if choice == 1
    set_players ComputerPlayer, ComputerPlayer if choice == 2
    set_players HumanPlayer, ComputerPlayer if choice == 3
    set_players ComputerPlayer, HumanPlayer if choice == 4
    if choice == 5
      self.current_player = nil
      self.other_player = nil
    end
  end

  def continue
    if self.current_player
      io.show board, self
      swap_players
      prompt_player_again
    end
  end

  def game_over(board)
    io.show board, self
    io.show_game_over_message board, self
  end

  def unavailable_position
    io.show_unavailable_position_message
    prompt_player_again
  end

  def incorrect_player
    io.show_incorrect_player_message
    prompt_player_again
  end

  def invalid_position
    io.show_invalid_position_message
    prompt_player_again
  end

  def restart
    self.board = Board.new
    self.board.add_observer self
    io.show_restart_message
    init_players
    swap_players
    continue if self.current_player
  end

  def swap_players
    self.current_player, self.other_player = self.other_player, self.current_player
  end

  def tie_game
    io.show board, self
    io.show_game_over_message board, self
    restart
  end

  def x_wins
    io.show board, self
    io.show_game_over_message board, self
    restart
  end

  def o_wins
    io.show board, self
    io.show_game_over_message board, self
    restart
  end

  private
  def set_players(player1, player2)
    self.current_player = player1.new 'x'
    self.other_player = player2.new 'o'
  end

  def prompt_player_again
    if self.current_player
      position = self.current_player.get_next_move board
      board.try_move current_player.char, position
    end
  end
end
