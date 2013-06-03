require 'tic_tac_toe_ai'
require 'game'

describe Game do
  let(:board) { TicTacToeAi.create_board }
  let(:game) { Game.new fake_io, board }
  let(:fake_io) { mock.as_null_object }
  let(:fake_cpu) { mock(get_next_move: 0, char: 'x') }
  let(:fake_human) { mock(get_next_move: 0, char: 'o') }

  before :each do
    init_fake_players
  end

  describe 'initialization' do
    it "should create a board that it is observing" do
      game.board.observers[0].should be game
    end
  end

  describe '#init_players' do
    it "should start two humans for option 1" do
      assert_menu_choice 1, HumanPlayer, HumanPlayer
    end

    it "should start two computers for option 2" do
      assert_menu_choice 2, ComputerPlayer, ComputerPlayer
    end

    it "should start human vs computer for option 3" do
      assert_menu_choice 3, HumanPlayer, ComputerPlayer
    end

    it "should start computer vs human for option 4" do
      assert_menu_choice 4, ComputerPlayer, HumanPlayer
    end

    it "should quit for option 5" do
      UserPrompter.should_receive(:get_menu_choice).and_return 5
      game.init_players
      game.current_player.should be_nil
    end
  end

  describe 'new games' do
    before :each do
      UserPrompter.stub(:get_menu_choice).and_return 1
      Board.any_instance.stub :notify_observers
      HumanPlayer.any_instance.stub :get_next_move
    end

    it "should clear the board" do
      game = Game.new(fake_io,
                      Board.new([nil,'o','x',nil,nil,nil,nil,nil,nil]))
      HumanPlayer.any_instance.stub :get_next_move
      game.restart
      game.board.spaces[1].should be_nil
      game.board.spaces[2].should be_nil
    end

    it "should let the user select players again" do
      UserPrompter.should_receive :get_menu_choice
      game.restart
    end

    it "should tell the IO to show a message" do
      fake_io.should_receive :show_restart_message
      game.restart
    end

    it "should add itself as an observer to the new board" do
      Board.any_instance.should_receive :add_observer
      game.restart
    end

    it "shows the board and a message when x wins" do
      fake_io.should_receive(:show).with game.board, game
      fake_io.should_receive :show_game_over_message

      game.x_wins
    end
  end

  describe '#unavailable_position' do
    before :each do
      game.board.stub :try_move
      fake_io.should_receive(:show_unavailable_position_message)
    end

    it "should tell the IO to show a message" do
      game.unavailable_position
    end

    it "should prompt the current player again" do
      game.current_player.should_receive :get_next_move
      game.unavailable_position
    end
  end

  describe '#incorrect_player' do
    before :each do
      game.board.stub :try_move
      fake_io.should_receive(:show_incorrect_player_message)
    end

    it "should tell the IO to show a message" do
      game.incorrect_player
    end

    it "should prompt the current player again" do
      game.current_player.should_receive :get_next_move
      game.incorrect_player
    end
  end

  describe '#invalid_position' do
    before :each do
      game.board.stub :try_move
      fake_io.should_receive(:show_invalid_position_message)
    end

    it "should tell the IO to show a message" do
      game.invalid_position
    end

    it "should prompt the current player again" do
      game.current_player.should_receive :get_next_move
      game.invalid_position
    end
  end

  describe '#continue' do
    it "should print the board after it is updated" do
      game.board.stub :try_move
      fake_io.should_receive(:show).with game.board, game
      game.continue
    end

    it "should swap players" do
      game.board.stub :try_move
      p1 = game.current_player
      p2 = game.other_player
      game.continue
      game.current_player.should eq p2
      game.other_player.should eq p1
    end

    it "should not do anything if current_player is nil" do
      game.board.stub :try_move
      game.current_player = nil
      fake_io.should_not_receive :show
      game.continue
    end
  end


  def assert_menu_choice(choice, class_1, class_2)
    UserPrompter.should_receive(:get_menu_choice).and_return choice
    game.init_players
    game.current_player.class.should be class_1
    game.other_player.class.should be class_2
  end

  def init_fake_players
    game.current_player = fake_cpu
    game.other_player = fake_human
  end
end
