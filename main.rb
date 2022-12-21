require_relative 'participant'
require_relative 'card'

# def user_interface
#   loop do
#     puts "Enter your action:"
#     user_action_choise = gets.chomp.to_i
#     break if user_action_choise == 99
#   end
# end

# puts "#{bank.name} #{bank.hand} #{bank.money}"
# puts "#{dealer.name} #{dealer.hand} #{dealer.money} #{dealer.pass_count}"
# puts "#{player.name} #{player.hand} #{player.money} #{player.pass_count}"

puts "The Black Jack programm\n"
puts "Welcome to the Game"
puts "Please, enter your name:"
# user_name = gets.chomp.capitalize
$user_name = 'Player'
puts "Hello, #{$user_name}! Lets begin"

def user_interface
  loop do
    main_menu_show
    main_menu_user_item_select = gets.to_i
    break if main_menu_process_user_choise(main_menu_user_item_select) == "exit"
  end
end

def main_menu_show
  puts "=" * 10
  MAIN_MENU.each { |key, item| puts format_message(key, item[:description]) }
end

def format_message(integer, string)
  format("%<integer>d  %<string>s", { integer: integer, string: string })
end

def main_menu_process_user_choise(menu_item)
  case menu_item
  when 1..13
    main_menu_execute(menu_item)
  when 99
    puts "=" * 10
    puts "The programm will be terminated"
    "exit"
  end
end

def main_menu_execute(key)
  MAIN_MENU[key][:reference].call
end

def start_new_game
  prepare_new_game
  loop do
    game_menu_show
    game_menu_user_item_select = gets.to_i
    break if game_menu_process_user_choise(game_menu_user_item_select) == "exit"
  end
end

def prepare_new_game
  erase_old_data
  create_default_data
  assign_defalut_variables
end

def erase_old_data
  Actor.erase_all_instances('new_game')
  Participant.erase_all_instances('new_game')
  Hand.erase_all_instances('new_game')
  $actors = {}
end

def create_default_data
  $actors = {
    bank: Actor.new('Bank'),
    dealer: Participant.new('Dealer'),
    player: Participant.new($user_name),
  }
end

def assign_defalut_variables
  $actors.each { |_, actor| actor.money = 100 if actor.class == Participant}
  $actors.each { |_, actor| actor.pass_count = 1 if actor.class == Participant}
  Card.all.each { |card| $actors[:bank].hand << card }
  $actors[:bank].hand.shuffle!
  p $actors
end

def game_menu_show
  puts "=" * 10
  GAME_MENU.each { |key, item| puts format_message(key, item[:description]) }
end

def game_menu_process_user_choise(menu_item)
  case menu_item
  when 1..13
    game_menu_execute(menu_item)
  when 91
    puts "Back to main menu"
    "exit"
  end
end

def game_menu_execute(key)
  GAME_MENU[key][:reference].call
end










MAIN_MENU = {
  1 => {
    description: 'Start a new game',
    reference: method(:start_new_game)
  },
  99 => { description: 'Close Game' }
}.freeze

GAME_MENU = {
  1 => {
    description: 'some item 1',
    reference: method(:start_new_game)
  },
  91 => {
    description: 'To main menu',
    reference: :return
  }
}.freeze


user_interface