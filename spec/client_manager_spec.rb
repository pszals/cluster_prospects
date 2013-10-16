require 'client_manager'
require 'client'

describe ClientManager do
  let(:client_manager) {ClientManager.new}
  let(:bob) {Client.new("bob")}

  it "adds a new client" do
    client_manager.add_client(bob)
    client_manager.clients.include?(bob)

    bob.add_task("Yak shaving", 1)
    bob.add_task("Yak milking", 2)
    bob.tasks.first.description.should include("Yak shaving")
    bob.tasks.last.description.should include("Yak milking")
    client_manager.clients.first.tasks.first.description.should include("Yak shaving")
    client_manager.clients.first.tasks.last.description.should include("Yak milking")
  end

  it "creates a new client" do
    client_manager.new_client("ralf")  
    client_manager.clients.first.should_not be_nil
  end

  it "adds client to client list only if client does not already exist" do
    client_manager.new_client("tim")
    client_manager.new_client("tim")
    client_manager.clients.size.should == 1
    client_manager.clients.first.tasks.size.should == 0

    client_manager.clients.first.add_task("do", 1)
    client_manager.clients.first.tasks.size.should == 1
    
    client_manager.new_client("tim")
    client_manager.clients.first.tasks.size.should == 1

    client_manager.new_client("tim")
    client_manager.clients.first.add_task("dot", 2)
    client_manager.clients.first.tasks.size.should == 2
  end
end
