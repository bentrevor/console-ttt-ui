class HumanPlayer
  attr_accessor :char

  def initialize(char)
    self.char = char
  end

  def get_next_move(_)
    ConsoleIO.gets.chomp
  end
end

