require 'client/states'

class ClientService
  attr_accessor :clients, :tasks, :users

  def initialize(clients, tasks, users)
    @clients = clients
    @tasks = tasks
    @users = users
  end

  def all
    @clients.all
  end

  def ascending_priority
    @clients.all(:order => [:priority.asc])
  end

  def descending_priority
    @clients.all(:order => [:priority.desc])
  end

  def ascending_name
    @clients.all(:order => [:name.asc])
  end

  def make_new_client(name, status)
    @clients.create(:name => name.to_s, :status => status.to_s)
  end

  def tasks_by_descending_priority
    @clients.each do |client|
      client.task_models.all(:order => [:priority.desc]) if client.task_models != []
    end
  end

  def get_by_id(id)
    @clients.get(id)
  end

  def get_prospects
    @clients.all(:order => [:name.asc], :status => ::Client::States::PROSPECT)
  end

  def get_dormant_clients
    @clients.all(:order => [:name.asc], :status => ::Client::States::DORMANT)
  end

  def get_active_clients
    @clients.all(:order => [:name.asc], :status => ::Client::States::ACTIVE) | @clients.all(:order => [:name.asc], :status => nil)
  end

  def update_client_status(id, status)
    client = get_by_id(id)
    client.update(:status => status)
  end

  def highest_priority_task(client)
    client.task_models.all(:order => [:priority.asc]).last
  end

  def show_highest_priority_task(client)
    "#{highest_priority_task(client).description}"
  end

  def datetime_highest_priority_task_created(client)
    "#{highest_priority_task(client).created_at.strftime('%m/%d/%Y')}" 
  end

  def status(client)
    client.status.to_s.capitalize
  end

  def complete_task(client_id, task_id)
    client = @clients.get(client_id.to_i)
    task = client.task_models.get(task_id.to_i)
    task.update(:completed => true)
    task.update(:priority => 0)
  end

  def add_task(client_id, task_description, priority)
    client = get_by_id(client_id)
    task = @tasks.create(:description => task_description, :priority => priority, :client_model => client)
    task.save
  end

  def has_incomplete_tasks?(client)
    client.task_models != [] and client.task_models.all(:order => [:priority.asc]).last.priority != 0
  end

  def clients_in_database?(clients)
    clients != []
  end

  def create_user(username, password)
    @users.create(:username => username, :password => password)
  end

  def find_by_username(username)
    @users.first(username: username)
  end

  def get_user_by_id(id)
    @users.get(id)
  end
end
