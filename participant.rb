require_relative 'actor'

class Participant < Actor
  @all = []

  class << self
    attr_reader :all

    def erase_all_instances(key)
      erase_all_instances! if key == 'new_game'
    end

    protected

    attr_writer :all

    def erase_all_instances!
      instance_variable_set(:@all, [])
    end
  end

  attr_accessor :pass_count

  def initialize(name, pass_count = 0)
    super(name)
    @pass_count = pass_count
    self.class.all << self
  end

  def calculate_cards_value
    case hand_has_ace_card?
    when true
      # puts "true"
      advanced_calculate_cards_value
    when false
      # puts "false"
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
    cards_value = simple_calculate_non_ace_cards_value
    cards_values = [cards_value]
    cards_values = process_non_ace_cards_values(cards_values)
    calculate_total_cards_value(cards_values)
  end

  def simple_calculate_non_ace_cards_value
    cards_value = 0
    @hand.each { |card| cards_value += card.value unless card.name.include?('A') }
    cards_value
  end

  def process_non_ace_cards_values(cards_values)
    @hand.each do |card|
      cards_values = calculate_non_ace_cards_values(card, cards_values) if card.name.include?('A')
    end
    cards_values.uniq
  end

  def calculate_non_ace_cards_values(card, cards_values)
    temp_card_values = []
    cards_values.each do |value|
      temp_card_values << value + card.value[:first]
      temp_card_values << value + card.value[:second]
    end
    temp_card_values
  end

  def calculate_total_cards_value(cards_values)
    # p cards_values
    cards_value = cards_values[0]
    cards_values.shift
    cards_values.each do |value|
      cards_value = value if value <= 21
    end
    # p cards_value
    cards_value
  end
end