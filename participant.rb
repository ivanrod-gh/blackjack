# frozen_string_literal: true

require_relative 'actor'

class Participant < Actor
  @all = []

  attr_accessor :pass_count

  def initialize(name, pass_count = 0)
    super(name)
    @pass_count = pass_count
    self.class.all << self
  end

  def make_bet(bank)
    raise "#{@name} doesn\'t have enough money!" if @money.zero?

    @money -= BET_SIZE
    bank.take_bet
  end

  def take_prize
    @money += BET_SIZE
  end

  def calculate_cards_value
    case hand_has_ace_card?
    when true
      advanced_calculate_cards_value
    when false
      simple_calculate_cards_value
    end
  end

  def hand_has_ace_card?
    @hand.each do |card|
      return true if card.name.include?('A')
    end
    false
  end

  def simple_calculate_cards_value
    cards_value = 0
    @hand.each { |card| cards_value += card.value }
    cards_value
  end

  def advanced_calculate_cards_value
    non_ace_value = simple_calculate_non_ace_cards_value
    values = mix_non_ace_and_ace_values([non_ace_value])
    calculate_total_cards_value(values)
  end

  def simple_calculate_non_ace_cards_value
    non_ace_value = 0
    @hand.each { |card| non_ace_value += card.value unless card.name.include?('A') }
    non_ace_value
  end

  def mix_non_ace_and_ace_values(values)
    @hand.each do |card|
      values = calculate_ace_from_non_ace_values(card, values) if card.name.include?('A')
    end
    values.uniq
  end

  def calculate_ace_from_non_ace_values(card, values)
    temp_values = []
    values.each do |value|
      temp_values << value + card.value[:first]
      temp_values << value + card.value[:second]
    end
    temp_values
  end

  def calculate_total_cards_value(values)
    cards_value = values[0]
    values.shift
    values.each do |value|
      cards_value = value if value <= 21
    end
    cards_value
  end
end
