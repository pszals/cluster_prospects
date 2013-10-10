require 'client_manager'
require 'client'

describe ClientManager do
  it "creates a new client" do
    client_manager = ClientManager.new
    bob = Client.new("bob")
    client_manager.add_client(bob)

    client_manager.clients.include?(bob)

    bob.add_task("Yak shaving", "0")
    bob.add_task("Yak milking", "0.5")
    bob.tasks.should include("Yak shaving")
    bob.tasks.should include("Yak milking")
    client_manager.clients[bob].should include("Yak shaving")
    client_manager.clients[bob].should include("Yak milking")
  end
end
