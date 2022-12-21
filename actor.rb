class Actor
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

  attr_accessor :money
  attr_reader :name, :hand

  def initialize(name, money = 0)
    @name = name
    @hand = []
    @money = money
    self.class.all << self
  end
end