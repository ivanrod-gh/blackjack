require_relative 'participant'
require_relative 'card'

# def main_interface
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

def main_interface
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
  when 1..reference_to_menu.size - 2
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

def game_interface
  prepare_new_game
  loop do
    menu_show(GAME_MENU)
    main_menu_user_item_select = gets.to_i
    break if menu_process_user_choise(GAME_MENU, main_menu_user_item_select, 91) == "exit"
  end
end

def prepare_new_game
  erase_old_data
  create_default_game_data
  assign_defalut_game_variables
end

def erase_old_data
  Actor.erase_all_instances('new_game')
  Participant.erase_all_instances('new_game')
  $actors = {}
end

def create_default_game_data
  $actors = {
    bank: Actor.new('Bank'),
    dealer: Participant.new('Dealer'),
    player: Participant.new($user_name),
  }
end

def assign_defalut_game_variables
  $actors.each { |_, actor| actor.money = 100 if actor.class == Participant}
end

def round_interface
  erase_old_round_data
  assign_default_round_variables
  loop do
  p $actors[:dealer]
  p $actors[:player]
    show_user_cards
    round_menu_show(ROUND_MENU)
    main_menu_user_item_select = gets.to_i
    break if menu_process_user_choise(ROUND_MENU, main_menu_user_item_select, 91) == "exit"
    calculate_pc_turn
    # p $decisions
  end
end

def erase_old_round_data
  $decisions = {}
  $actors.each { |_, actor| actor.erase_hand }
end

def assign_default_round_variables
  $actors[:bank].get_all_cards
  $actors[:bank].hand.shuffle!
  $actors.each do |_, actor|
    if actor.class == Participant
      8.times { actor.get_cards_from_bank($actors[:bank]) }
    end
  end
  $actors.each { |_, actor| actor.pass_count = 1 if actor.class == Participant}
  # p $actors
end

def show_user_cards
  show_cards_horizontally($actors[:player].hand)
end

def show_cards_horizontally(cards_array)
  puts "Your cards:"
  create_first_card_image_line(cards_array.size)
  create_second_card_image_line(cards_array.size)
  create_central_card_image_line(cards_array)
  create_second_card_image_line(cards_array.size)
  create_first_card_image_line(cards_array.size)
end

def create_first_card_image_line(repeat_count)
  print "#" * 6 * repeat_count + "\n"
end

def create_second_card_image_line(repeat_count)
  print "#    #" * repeat_count + "\n"
end

def create_central_card_image_line(cards_array)
  line = ''
  cards_array.each do |card|
    name_length = card.name.length
    space_before = ' ' if name_length < 4
    space_after = ' ' if name_length == 2
    line += "##{space_before}#{card.name}#{space_after}#"
  end
  print "#{line}\n"
end

def round_menu_show(reference_to_menu)
  puts "=" * 10
  # reference_to_menu.each { |key, item| puts format_message(key, item[:description]) if key.class == Integer }
  puts format_message(1, reference_to_menu[1][:description]) if $actors[:player].pass_count > 0
  puts format_message(2, reference_to_menu[2][:description]) if $actors[:player].hand.size < 3
  puts format_message(3, reference_to_menu[3][:description])
end

def user_passed
  $decisions = {user_choise: :pass}
end

def user_ask_extra_card
  $decisions = {user_choise: :extra_card}
end

def round_ask_show_cards
  $decisions = {user_choise: :show_cards}
end

def calculate_pc_turn
  p cards_value = $actors[:dealer].calculate_cards_value
end











MAIN_MENU = {
  1 => {
    description: 'Start a new game',
    reference: method(:game_interface)
  },
  99 => { description: 'Close Game' },
  exit: { description: "=" * 10 + "\nThe programm will be terminated", action: 'exit' }
}.freeze

#start new game
#change name
#show records
#exit game

GAME_MENU = {
  1 => {
    description: 'Start a new round',
    reference: method(:round_interface)
  },
  91 => { description: 'To main menu' },
  exit: { description: "=" * 10 + "\nBack to main menu", action: 'exit' }
}.freeze

#start new round
#show balance
#to main menu

ROUND_MENU = {
  1 => {
    description: 'Pass',
    reference: method(:user_passed)
  },
  2 => {
    description: 'Ask for an extra card',
    reference: method(:user_ask_extra_card)
  },
  3 => {
    description: 'Ask for show cards',
    reference: method(:round_ask_show_cards)
  },
  91 => { description: 'To game menu' },
  exit: { description: "=" * 10 + "\nBack to game menu", action: 'exit' }
}.freeze

#pass
#get card
#open cards
#to game menu

main_interface
