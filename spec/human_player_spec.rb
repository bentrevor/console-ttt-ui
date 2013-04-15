require 'human_player'
require 'console_io'

describe HumanPlayer do
  let(:human_player) { HumanPlayer.new 'x' }

  it "should send the gets message to ConsoleIO" do
    ConsoleIO.should_receive(:gets).and_return "1\n"
    human_player.get_next_move stub
  end
end
