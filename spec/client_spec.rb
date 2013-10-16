require 'client'

describe Client do
  it "adds a new task" do
    client = Client.new("New Client")
    client.add_task("Task Description", 1)

    client.tasks.first.description.should == "Task Description"
  end

  it "returns the highest priority task" do
    client = Client.new("Bob")
    client.add_task("Eat snails", 1)
    client.add_task("Eat chocolate", 0)
    client.top_task.description.should == "Eat snails"
  end

  it "sorts tasks by priority" do
    client = Client.new("Me")
    client.add_task("Eat snails", 1)
    client.add_task("mow", 1)
    client.add_task("cheese", 2)
    client.add_task("Eat chocolate", 3)
    client.add_task("highest", 3)
    client.add_task("highest1", 3)

    client.top_task.description.should == "highest1"
  end
end
