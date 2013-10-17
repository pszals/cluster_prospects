class Task
  include DataMapper::Resource
  property :id, Serial
  property :priority, Integer
  property :description, String
  property :completed, :default => false

  property :created_at, DateTime
  property :updated_at, DateTime
  
  belongs_to :client
end
