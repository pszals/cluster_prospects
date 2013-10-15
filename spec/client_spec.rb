require 'client'

describe Client do
  it "adds a new task" do
    client = Client.new("New Client")
    client.add_task("Task Description")

    client.tasks.include?("Task Description").should be_true
  end

  it "returns the highest priority task" do
    client = Client.new("Bob")
    client.add_task("Eat snails")
    client.add_task("Eat chocolate")

    client.top_task.should == "Eat chocolate"
  end
end
