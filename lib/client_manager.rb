require_relative 'client'
require_relative 'task'

class ClientManager
  attr_accessor :clients

  def initialize
    @clients = [] 
  end

  def add_client(client)
    @clients << client
  end

  def new_client(name)
    add_client(Client.new(name)) if @clients.select{ |client| client.name == name }.length == 0
  end
end
