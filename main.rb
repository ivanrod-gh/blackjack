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
    menu_show(MAIN_MENU)
    main_menu_user_item_select = gets.to_i
    break if menu_process_user_choise(MAIN_MENU, main_menu_user_item_select, 99) == "exit"
  end
end

def menu_show(reference_to_menu)
  puts "=" * 10
  reference_to_menu.each { |key, item| puts format_message(key, item[:description]) if key.class == Integer }
end

def format_message(integer, string)
  format("%<integer>d  %<string>s", { integer: integer, string: string })
end

def menu_process_user_choise(reference_to_menu, menu_item, exit_item_number)
  case menu_item
  when 1..reference_to_menu.size - 1
    menu_execute(reference_to_menu, menu_item)
  when exit_item_number
    response_to_user_choose_exit(reference_to_menu)
  end
end

def response_to_user_choose_exit(reference_to_menu)
  puts reference_to_menu[:exit][:description]
  reference_to_menu[:exit][:reference].call unless reference_to_menu[:exit][:reference].nil?
  reference_to_menu[:exit][:action]
end

def menu_execute(reference_to_menu, key)
  reference_to_menu[key][:reference].call
end

def start_new_game
  prepare_new_game
  loop do
    menu_show(GAME_MENU)
    main_menu_user_item_select = gets.to_i
    break if menu_process_user_choise(GAME_MENU, main_menu_user_item_select, 91) == "exit"
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
  # p $actors
end

def start_new_round
  prepare_new_game
  loop do
    menu_show(ROUND_MENU)
    main_menu_user_item_select = gets.to_i
    break if menu_process_user_choise(ROUND_MENU, main_menu_user_item_select, 91) == "exit"
  end
end








MAIN_MENU = {
  1 => {
    description: 'Start a new game',
    reference: method(:start_new_game)
  },
  99 => { description: 'Close Game' },
  exit: { description: "=" * 10 + "\nThe programm will be terminated", action: 'exit' }
}.freeze

GAME_MENU = {
  1 => {
    description: 'Start a new round',
    reference: method(:start_new_round)
  },
  91 => { description: 'To main menu' },
  exit: { description: "=" * 10 + "\nBack to main menu", action: 'exit' }
}.freeze

ROUND_MENU = {
  1 => {
    description: 'some item 1',
    reference: method(:start_new_round)
  },
  91 => { description: 'To game menu' },
  exit: { description: "=" * 10 + "\nBack to game menu", action: 'exit' }
}.freeze

user_interface