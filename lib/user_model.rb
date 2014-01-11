class UserModel
  include DataMapper::Resource
  include BCrypt

  property :id, Serial
  property :username, String, :length => 3..50
  property :password, BCryptHash

  has n, :client_models

  def authenticate(attempted_password)
    self.password == attempted_password
  end
end


