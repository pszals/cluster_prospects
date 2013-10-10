class Client
  attr_accessor :tasks, :name

  def initialize(name)
    @tasks = {}
    @name = name
  end

  def add_task(task_description, priority)
    tasks[task_description] = priority
  end
end
