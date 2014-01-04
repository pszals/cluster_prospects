require 'client/states'

class ClientService
  attr_accessor :db

  def initialize(db)
    @db = db
  end

  def all
    @db.all
  end

  def ascending_priority
    @db.all(:order => [:priority.asc])
  end

  def descending_priority
    @db.all(:order => [:priority.desc])
  end

  def ascending_name
    @db.all(:order => [:name.asc])
  end

  def create(details)
    @db.create(details)
  end

  def tasks_by_descending_priority
    @db.each do |client|
      client.task_models.all(:order => [:priority.desc]) if client.task_models != []
    end
  end

  def get_by_id(id)
    @db.get(id)
  end

  def get_prospects
    @db.all(:order => [:name.asc], :status => ::Client::States::PROSPECT)
  end

  def get_dormant_clients
    @db.all(:order => [:name.asc], :status => ::Client::States::DORMANT)
  end

  def get_active_clients
    @db.all(:order => [:name.asc], :status => ::Client::States::ACTIVE) | @db.all(:order => [:name.asc], :status => nil)
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
end
