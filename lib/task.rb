class Task
  attr_accessor :priority, :description, :completed

  def initialize
    @priority = priority
    @description = description
    @completed = false
  end

  def complete
    @completed = true
    @priority = 0
  end
end
