# frozen_string_literal: true

require_relative 'participant'
require_relative 'card'

class Interface
  class << self
    attr_accessor :user_name, :actors, :decisions, :records, :menu
  end
end

system 'clear'
print "The Black Jack programm\n\n"
puts "Welcome to the Game!"

def input_user_name
  puts "Please, enter your name (minimum 3 characters without digits and spaces):"
  loop do
    Interface.user_name = gets.chomp.capitalize
    Interface.user_name =~ /^[a-z]{3,}$/i ? break : (puts "Invalid name format. Please try again")
  end
  system 'clear'
  puts "Hello, #{Interface.user_name}! Lets begin"
  sleep(0.5)
end

def main_interface
  input_user_name
  Interface.records = []
  loop do
    shown_items_numbers = menu_show(MAIN_MENU)
    menu_player_select_and_execute(MAIN_MENU, shown_items_numbers, 99)
    break if break_was_called
  rescue RuntimeError
    retry
  end
end

def menu_show(reference_to_menu)
  puts "=" * 10
  shown_items_numbers = []
  reference_to_menu.each do |key, item|
    if key.instance_of?(Integer)
      puts format_message(key, item[:description])
      shown_items_numbers.push(key)
    end
  end
  shown_items_numbers
end

def format_message(integer, string)
  format("%2<integer>d  %<string>s", { integer: integer, string: string })
end

def menu_player_select_and_execute(reference_to_menu, shown_items_numbers, exit_item_number)
  menu_user_item_select = gets.to_i
  system 'clear'
  if menu_user_item_select == exit_item_number
    response_to_user_choose_exit(reference_to_menu)
  elsif shown_items_numbers.include?(menu_user_item_select)
    menu_execute(reference_to_menu, menu_user_item_select)
  else
    raise
  end
end

def response_to_user_choose_exit(reference_to_menu)
  puts reference_to_menu[:exit][:description]
  reference_to_menu[:exit][:reference]&.call
  Interface.menu = reference_to_menu[:exit][:action]
end

def menu_execute(reference_to_menu, key)
  reference_to_menu[key][:reference].call
end

def break_was_called
  if Interface.menu == 'exit'
    Interface.menu = ''
    return true
  end
  false
end

def show_records
  puts "Your records:"
  Interface.records.each { |record| puts record }
end

def game_interface
  prepare_new_game
  loop do
    shown_items_numbers = game_menu_show(GAME_MENU)
    menu_player_select_and_execute(GAME_MENU, shown_items_numbers, 91)
    break if break_was_called
  rescue RuntimeError
    retry
  end
end

def prepare_new_game
  puts "At the beginning you and the Bank have #{Actor::INITIAL_MONEY} coins"
  sleep(0.25)
  erase_old_data
  create_default_game_data
  assign_defalut_game_variables
end

def erase_old_data
  Actor.erase_all_instances('new_game')
  Participant.erase_all_instances('new_game')
  Interface.actors = {}
end

def create_default_game_data
  Interface.actors = {
    bank: Actor.new('Bank'),
    dealer: Participant.new('Dealer'),
    player: Participant.new(Interface.user_name)
  }
end

def assign_defalut_game_variables
  Interface.actors.each { |_, actor| actor.money = Actor::INITIAL_MONEY if actor.instance_of?(Participant) }
end

def game_menu_show(reference_to_menu)
  puts "=" * 10
  shown_items_numbers = []
  shown_items_numbers.push(menu_item_show(reference_to_menu, 1)) if all_participant_have_money
  shown_items_numbers.push(menu_item_show(reference_to_menu, 2))
  shown_items_numbers.push(menu_item_show(reference_to_menu, 91))
  shown_items_numbers
end

def all_participant_have_money
  if Interface.actors[:player].money.zero?
    puts "--you have no money--"
    return false
  elsif Interface.actors[:dealer].money.zero?
    puts "--bank have no money--"
    return false
  end
  true
end

def user_quit_game
  record = create_record
  user_victory_postscript = " as victorious!" if Interface.actors[:dealer].money.zero?
  puts "You choose end this game#{user_victory_postscript}\n\nYour record: #{record}"
  Interface.records << record
  Interface.menu = 'exit'
  sleep(1)
end

def create_record
  record = "#{Interface.actors[:player].name}, money: #{Interface.actors[:player].money}, "
  record += "in bank: #{Interface.actors[:dealer].money}\n"
  record
end

def round_interface
  preparations_before_rounds
  loop do
    process_new_round_common_actions
    break if break_was_called

    proceed_user_choise
    break if break_was_called
  rescue RuntimeError
    retry
  end
end

def preparations_before_rounds
  erase_old_round_data
  assign_default_round_variables
  take_bet
end

def erase_old_round_data
  Interface.decisions = {}
  Interface.actors.each { |_, actor| actor.erase_hand }
end

def assign_default_round_variables
  recieve_and_shuffle_bank_cards
  Interface.actors.each do |_, actor|
    2.times { actor.get_cards_from_bank(Interface.actors[:bank]) } if actor.instance_of?(Participant)
  end
  Interface.actors[:player].pass_count = 1
end

def recieve_and_shuffle_bank_cards
  Interface.actors[:bank].accumulate_all_cards
  Interface.actors[:bank].hand.shuffle!
end

def take_bet
  raise "No money to proceed!" if Interface.actors[:player].money.zero? || Interface.actors[:dealer].money.zero?

  Interface.actors.each { |_, actor| actor.make_bet(Interface.actors[:bank]) if actor.instance_of?(Participant) }
end

def process_new_round_common_actions
  show_participants_cards(:closed, :open)
  Interface.decisions = {}
  shown_items_numbers = round_menu_show(ROUND_MENU)
  menu_player_select_and_execute(ROUND_MENU, shown_items_numbers, 91)
end

def show_participants_cards(condition_for_dealer, condition_for_player)
  show_cards(Interface.actors[:dealer], condition_for_dealer)
  show_cards(Interface.actors[:player], condition_for_player)
end

def show_cards(actor, condition)
  show_cards_horizontally(actor, actor.hand, condition)
end

def show_cards_horizontally(actor, cards, condition)
  show_message_corresponding_shown_cards(actor)
  create_first_card_image_line(cards.size)
  create_second_card_image_line(cards.size)
  create_central_card_image_line(cards, condition)
  create_second_card_image_line(cards.size)
  create_first_card_image_line(cards.size)
end

def show_message_corresponding_shown_cards(actor)
  case actor == Interface.actors[:dealer]
  when true
    puts "Dealer cards:"
  when false
    puts "Your cards:"
  end
end

def create_first_card_image_line(repeat_count)
  print "#{'#' * 6 * repeat_count}\n"
end

def create_second_card_image_line(repeat_count)
  print "#{'#    #' * repeat_count}\n"
end

def create_central_card_image_line(cards, condition)
  line = ''
  cards.each do |card|
    name = condition == :open ? card.name : "**"
    name_length = name.length
    space_before = ' ' if name_length < 4
    space_after = ' ' if name_length == 2
    line += "##{space_before}#{name}#{space_after}#"
  end
  print "#{line}\n"
end

def round_menu_show(reference_to_menu)
  puts "=" * 10
  shown_items_numbers = []
  show_round_menu_item1(shown_items_numbers, reference_to_menu)
  show_round_menu_item2(shown_items_numbers, reference_to_menu)
  show_round_menu_item3(shown_items_numbers, reference_to_menu)
  show_round_menu_item4(shown_items_numbers, reference_to_menu)
  shown_items_numbers
end

def show_round_menu_item1(shown_items_numbers, reference_to_menu)
  case Interface.actors[:player].pass_count.positive?
  when true
    shown_items_numbers.push(menu_item_show(reference_to_menu, 1))
  when false
    (puts "-")
  end
end

def show_round_menu_item2(shown_items_numbers, reference_to_menu)
  case Interface.actors[:player].hand.size < 3
  when true
    shown_items_numbers.push(menu_item_show(reference_to_menu, 2))
  when false
    (puts "-")
  end
end

def show_round_menu_item3(shown_items_numbers, reference_to_menu)
  first_round = Interface.actors[:player].pass_count == 1 && Interface.actors[:player].hand.size == 2
  first_round ? (puts "-") : shown_items_numbers.push(menu_item_show(reference_to_menu, 3))
end

def show_round_menu_item4(shown_items_numbers, reference_to_menu)
  shown_items_numbers.push(menu_item_show(reference_to_menu, 91))
end

def menu_item_show(reference_to_menu, item_number)
  puts format_message(item_number, reference_to_menu[item_number][:description])
  item_number
end

def user_passed
  Interface.decisions[:player] = :pass
end

def user_ask_extra_card
  Interface.decisions[:player] = :extra_card
end

def round_ask_show_cards
  Interface.decisions[:player] = :show_cards
end

def proceed_user_choise
  calculate_pc_turn unless Interface.decisions[:player] == :show_cards
  proceed_actors_decisions
end

def calculate_pc_turn
  cards_value = Interface.actors[:dealer].calculate_cards_value
  Interface.decisions[:dealer] = calculate_pc_decision(cards_value)
end

def calculate_pc_decision(cards_value)
  if cards_value < 17 && Interface.actors[:dealer].hand.size < 3
    :extra_card
  else
    :pass
  end
end

def proceed_actors_decisions
  process_decisions_than_continue_game
  process_round_conditions
end

def process_decisions_than_continue_game
  Interface.decisions.each do |actor, decision|
    case decision
    when :pass
      Interface.actors[actor].pass_count -= 1 if actor == :player
    when :extra_card
      Interface.actors[actor].get_cards_from_bank(Interface.actors[:bank])
    end
  end
end

def process_round_conditions
  calculate_round_ending if Interface.decisions[:player] == :show_cards
  calculate_round_ending if Interface.actors[:player].hand.size == 3
end

def calculate_round_ending
  pc_cards_value = Interface.actors[:dealer].calculate_cards_value
  user_cards_value = Interface.actors[:player].calculate_cards_value
  result = calculate_winner(pc_cards_value, user_cards_value)
  announce_winner(result)
end

def calculate_winner(pc_cards_value, user_cards_value)
  if (user_cards_value > 21 && pc_cards_value > 21) || user_cards_value == pc_cards_value
    :draw
  elsif user_cards_value > pc_cards_value && user_cards_value <= 21 || pc_cards_value > 21
    :player
  else
    :dealer
  end
end

def announce_winner(result)
  show_participants_cards(:open, :open)
  sleep(0.5)
  show_winner_or_draw(result)
  proceed_money_transfer(result)
  show_result_for_user(result)
  Interface.menu = 'exit'
end

def show_winner_or_draw(result)
  case result
  when :draw
    puts "\nRound draw!"
  when :dealer
    puts "\n#{Interface.actors[result].name} wins!"
  else
    puts "\nRound ended! Winner is - #{Interface.actors[result].name}!"
  end
end

def proceed_money_transfer(result)
  Interface.actors.each { |_, actor| proceed_participant_money(actor, result) if actor.instance_of?(Participant) }
end

def proceed_participant_money(actor, result)
  case result
  when :draw
    Interface.actors[:bank].give_prize(actor)
  when :player
    2.times { Interface.actors[:bank].give_prize(actor) if actor == Interface.actors[:player] }
  when :dealer
    2.times { Interface.actors[:bank].give_prize(actor) if actor == Interface.actors[:dealer] }
  end
end

def show_result_for_user(result)
  case result
  when :draw
    message_in_case_of_draw
  when :player
    message_in_case_of_player_victory
  when :dealer
    message_in_case_of_dealer_victory
  end
end

def message_in_case_of_draw
  puts "\nYou get your money back and now you have #{Interface.actors[:player].money} coins"
end

def message_in_case_of_player_victory
  puts "\nYou increase your money and now you have #{Interface.actors[:player].money} coins"
  puts "Now you get the whole bank\'s money!" if Interface.actors[:dealer].money.zero?
end

def message_in_case_of_dealer_victory
  puts "\nYou lose your bet and now you have #{Interface.actors[:player].money} coins"
  puts "Now you have no money to proceed!" if Interface.actors[:player].money.zero?
end

def show_status
  puts " Name: #{Interface.actors[:player].name}"
  puts " Money: #{Interface.actors[:player].money}"
  puts " In Bank: #{Interface.actors[:dealer].money}"
end

def user_quit_round
  puts "You choose end this round"
  result = :dealer
  proceed_money_transfer(result)
  show_result_for_user(result)
  Interface.menu = 'exit'
  sleep(1)
end

MAIN_MENU = {
  1 => {
    description: 'Start a new game',
    reference: method(:game_interface)
  },
  2 => {
    description: 'Show records',
    reference: method(:show_records)
  },
  3 => {
    description: 'Change player\'s name',
    reference: method(:input_user_name)
  },
  99 => { description: 'Close programm' },
  exit: { description: "The programm will be terminated", action: 'exit' }
}.freeze

GAME_MENU = {
  1 => {
    description: 'Start a new round',
    reference: method(:round_interface)
  },
  2 => {
    description: 'Show your status',
    reference: method(:show_status)
  },
  91 => { description: 'To main menu' },
  exit: {
    description: "=" * 10,
    reference: method(:user_quit_game),
    action: 'exit'
  }
}.freeze

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
  exit: {
    description: "=" * 10,
    reference: method(:user_quit_round),
    action: 'exit'
  }
}.freeze

main_interface

sleep(1.5)
system 'clear'
