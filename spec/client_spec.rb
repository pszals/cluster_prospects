require 'client'

describe Client do
  it "adds a new task" do
    name = "New Client"
    client = Client.new(name)
    client.add_task("Task Description", "Task Priority")

    client.tasks.include?("Task Description").should be_true
  end

  it "returns the highest priority task" do
    name = "bob"
    client = Client.new(name)
    client.add_task("Eat chocolate", 8)
    client.add_task("Eat snails", 1)

    client.top_task.should == ("Eat chocolate")
  end
end
