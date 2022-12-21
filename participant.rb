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
end