require_relative 'client'

class ClientManager
  attr_accessor :clients

  def initialize
    @clients = {} 
  end

  def add_client(client)
    @clients[client.name] = client
  end

  def new_client(name)
    if !(@clients.has_key?(name))
      client = Client.new(name)     
      add_client(client) 
    end
  end
end
