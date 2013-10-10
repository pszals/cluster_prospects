class ClientManager
  attr_accessor :clients

  def initialize
    @clients = {} 
  end

  def add_client(client)
    @clients[client] = client.tasks
  end
end
