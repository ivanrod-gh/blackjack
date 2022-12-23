module All
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