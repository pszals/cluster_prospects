require_relative 'task'

class Client
  attr_accessor :tasks, :name

  def initialize(name)
    @name = name
    @tasks = []
  end

  def add_task(task_description, priority)
    task = Task.new
    task.description = task_description
    task.priority = priority
    tasks << task
  end

  def top_task
    sort_tasks
    
    @tasks.first
  end

  def sort_tasks
    @tasks.sort! {|a,b| b.priority <=> a.priority}
  end
end
