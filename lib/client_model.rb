class ClientModel
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :status, String

  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :task_models

  belongs_to :user_model, required: false
end
