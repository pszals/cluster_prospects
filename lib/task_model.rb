class TaskModel
  include DataMapper::Resource
  property :id, Serial
  property :priority, Integer
  property :description, String
  property :completed, Boolean, :default => false

  property :created_at, DateTime
  property :updated_at, DateTime
  
  belongs_to :client_model
end
