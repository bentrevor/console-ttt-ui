require 'user_prompter'

describe UserPrompter do
  let(:fake_io) { stub }
  let(:board) { Board.new }

  describe 'menu choice' do
    it "should only return a number from 1 to 5" do
      fake_io.stub :show_menu
      fake_io.should_receive(:gets).and_return "bla\n", "6\n", "0\n", "4\n"
      UserPrompter.get_menu_choice(fake_io).should eq 4
    end

    it "should call io#show_menu" do
      fake_io.should_receive(:show_menu)
      fake_io.should_receive(:gets).and_return "4\n"
      UserPrompter.get_menu_choice(fake_io)
    end
  end
end
