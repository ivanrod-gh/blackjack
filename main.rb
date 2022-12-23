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
    shown_items_numbers = menu_show(MAIN_MENU)
    menu_user_item_select = gets.to_i
    break if menu_process_user_choise(MAIN_MENU, menu_user_item_select, shown_items_numbers, 99) == "exit"
  rescue
  end
end

def menu_show(reference_to_menu)
  puts "=" * 10
  shown_items_numbers = []
  reference_to_menu.each do |key, item|
    if key.class == Integer
      puts format_message(key, item[:description])
      shown_items_numbers.push(key)
    end
  end
  shown_items_numbers
end





# def round_menu_show(reference_to_menu)
#   puts "=" * 10
#   shown_items_numbers = []
#   # reference_to_menu.each { |key, item| puts format_message(key, item[:description]) if key.class == Integer }
#   shown_items_numbers.push(menu_item_show(reference_to_menu, 1)) if $actors[:player].pass_count > 0
#   shown_items_numbers.push(menu_item_show(reference_to_menu, 2)) if $actors[:player].hand.size < 3
#   shown_items_numbers.push(menu_item_show(reference_to_menu, 3))
#   shown_items_numbers
# end









def format_message(integer, string)
  format("%<integer>d  %<string>s", { integer: integer, string: string })
end

def menu_process_user_choise(reference_to_menu, menu_item, shown_items_numbers, exit_item_number)
  # case menu_item
  # when 1..reference_to_menu.size - 2
  #   menu_execute(reference_to_menu, menu_item)
  # when exit_item_number
  #   response_to_user_choose_exit(reference_to_menu)
  # end
  # puts menu_item
  # p shown_items_numbers

  if menu_item == exit_item_number
    response_to_user_choose_exit(reference_to_menu)
  elsif shown_items_numbers.include?(menu_item)
    menu_execute(reference_to_menu, menu_item)
  else
    raise
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
    shown_items_numbers = menu_show(GAME_MENU)
    menu_user_item_select = gets.to_i
    break if menu_process_user_choise(GAME_MENU, menu_user_item_select, shown_items_numbers, 91) == "exit"
  rescue
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
  take_bet
  loop do

    show_cards($actors[:player])
    shown_items_numbers = round_menu_show(ROUND_MENU)
    menu_user_item_select = gets.to_i
    puts "smthin"
    break if menu_process_user_choise(ROUND_MENU, menu_user_item_select, shown_items_numbers, 91) == "exit"
    puts "calv"
    calculate_pc_turn

    puts "bank money: #{$actors[:bank].money}"
    p $actors[:dealer]
    p $actors[:player]
    p $decisions
  rescue
    # perform_planned_actions
    # calculate_results
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
      2.times { actor.get_cards_from_bank($actors[:bank]) }
    end
  end
  $actors.each { |_, actor| actor.pass_count = 1 if actor.class == Participant}
  # p $actors
end

def take_bet
  raise "No money to proceed!" if $actors[:player].money.zero? || $actors[:player].money.zero?
  $actors.each { |_, actor| actor.make_bet($actors[:bank]) if actor.class == Participant}
end

def show_cards(actor)
  show_cards_horizontally(actor, actor.hand)
end

def show_cards_horizontally(actor, cards)
  show_message_corresponding_shown_cards(actor)
  create_first_card_image_line(cards.size)
  create_second_card_image_line(cards.size)
  create_central_card_image_line(cards)
  create_second_card_image_line(cards.size)
  create_first_card_image_line(cards.size)
end

def show_message_corresponding_shown_cards(actor)
  case actor.name.include?('Deal')
  when true
    puts "Dealer cards:"
  when false
    puts "Your cards:"
  end
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
  shown_items_numbers = []
  # reference_to_menu.each { |key, item| puts format_message(key, item[:description]) if key.class == Integer }
  shown_items_numbers.push(menu_item_show(reference_to_menu, 1)) if $actors[:player].pass_count > 0
  shown_items_numbers.push(menu_item_show(reference_to_menu, 2)) if $actors[:player].hand.size < 3
  shown_items_numbers.push(menu_item_show(reference_to_menu, 3))
  shown_items_numbers.push(menu_item_show(reference_to_menu, 91))
  shown_items_numbers
end

def menu_item_show(reference_to_menu, item_number)
  puts format_message(item_number, reference_to_menu[item_number][:description])
  item_number
end






def safe_user_select_item_number_from_items(shown_items_numbers)
  user_choise = gets.to_i
  raise unless shown_items_numbers.include?(user_choise)

  user_choise
end






def user_passed
    $decisions[:user_choise] = :pass
end

def user_ask_extra_card
    $decisions[:user_choise] = :extra_card
end

def round_ask_show_cards
    $decisions[:user_choise] = :show_cards
end

def calculate_pc_turn
  p cards_value = $actors[:dealer].calculate_cards_value
  calculate_pc_desicion(cards_value)
  $decisions
end

def calculate_pc_desicion(cards_value)
  if cards_value < 17
    $decisions[:dealer_choise] = :extra_card
  elsif cards_value >= 18
    $decisions[:dealer_choise] = :pass
  end
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
