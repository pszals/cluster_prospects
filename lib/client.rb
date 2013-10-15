class Client
  attr_accessor :tasks, :name

  def initialize(name)
    @name = name
    @tasks = []
  end

  def add_task(task_description)
    tasks << task_description
  end

  def top_task
    @tasks.last
  end
end
