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
    @db.all(:status => "prospect")
  end
end
