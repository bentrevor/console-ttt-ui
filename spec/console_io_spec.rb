require 'console_io'

describe ConsoleIO do
  let(:board) { Board.new }
  let(:printable_board) { ConsoleIO.make_printable board }

  describe '#make_printable' do
    it "should print a '.' for each empty space" do
      printable_board.should eq "   ...\n   ...\n   ...\n\n"
    end

    it "should print x's and o's" do
      board.place 0
      board.place 1
      printable_board.should eq "   xo.\n   ...\n   ...\n\n"
    end
  end

  it "should automatically restart the game" do
    fake_game = stub
    fake_game.should_receive :restart
    $stdout.stub :puts
    ConsoleIO.show_game_over_message board, fake_game
  end

  describe '#menu_string' do
    it "should show the options for the game" do
      string = ConsoleIO.menu_string
      string.should eq "(1)human v human\n(2)computer v computer\n(3)human v computer\n(4)computer v human\n(5)quit"
    end
  end
end
