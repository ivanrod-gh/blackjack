# frozen_string_literal: true

require_relative 'all'

class Actor
  singleton_class.include All

  BET_SIZE = 10
  INITIAL_MONEY = 100

  @all = []

  attr_accessor :money
  attr_reader :name, :hand

  def initialize(name, money = 0)
    @name = name
    @hand = []
    @money = money
    validate!
    self.class.all << self
  end

  def erase_hand
    erase_hand!
  end

  def accumulate_all_cards
    accumulate_all_cards!
  end

  def get_cards_from_bank(bank)
    get_cards_from_bank!(bank)
  end

  def take_bet
    @money += BET_SIZE
  end

  def give_prize(participant)
    raise "Prize calling for invalid target!" unless participant.instance_of?(Participant)
    raise "There is no more money in Bank!" if @money.zero?

    @money -= BET_SIZE
    participant.take_prize
  end

  protected

  def validate!
    raise "Name must have at least 3 characters!" if @name.length < 3
    raise "Money must be integer!" unless @money.instance_of?(Integer)
  end

  def erase_hand!
    @hand = []
  end

  def accumulate_all_cards!
    raise "Method called for non-bank actor!" unless name.include?('Bank')

    Card.all.each { |card| hand << card }
  end

  def get_cards_from_bank!(bank)
    card = bank.hand[0]
    hand << card
    bank.hand.delete(card)
  end
end
