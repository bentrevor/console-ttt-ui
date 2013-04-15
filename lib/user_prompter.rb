class UserPrompter
  def self.get_menu_choice(io)
    io.show_menu
    choice = convert_input_to_integer io
    return choice if (1..5).include? choice
    get_menu_choice io
  end

  private
  def self.convert_input_to_integer(io)
    input = io.gets.chomp
    input = input.to_i if input.to_i.to_s == input
  end
end
