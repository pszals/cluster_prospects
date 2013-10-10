require 'client'

describe Client do
  it "adds a new task" do
    name = "New Client"
    client = Client.new(name)
    client.add_task("Task Description", "Task Priority")

    client.tasks.include?("Task Description").should be_true
  end
end
