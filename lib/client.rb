class Client
  attr_accessor :tasks, :name

  def initialize(name)
    @tasks = {}
    @name = name
  end

  def add_task(task_description, priority)
    tasks[task_description] = priority
  end

  def top_task
    sorted_tasks = @tasks.sort {|task1, task2| task2[1] <=> task1[1]}
    sorted_tasks.flatten[0]
  end
end
