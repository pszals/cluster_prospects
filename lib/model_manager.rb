class ModelManager

  def initialize
    # make or use database
  end

  def add_task(id, description)
    task = TaskModel.new(description)
    Client.get(id) << task
  end

  def add_client(name)
    Manager << Client.new(name)
  end
end
