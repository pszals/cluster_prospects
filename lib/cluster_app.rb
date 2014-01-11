$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'bundler'
require 'bcrypt'
require 'data_mapper'
require 'client_service'
require 'client_model'
require 'task_model'
require 'presenter'
require 'user_model'
require 'bcrypt'
require 'warden'

DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_ROSE_URL"] || "postgres://pszalwinski: @localhost/cluster")
DataMapper.finalize
DataMapper.auto_upgrade!

class Sinatra_Cluster < Sinatra::Base
  attr_reader :params

  use Rack::Session::Cookie
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = Sinatra_Cluster
    manager.serialize_into_session {|user| user.id}
    manager.serialize_from_session {|id| UserModel.find(id) }
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params["username"] || params["password"]
    end

    def authenticate!
      user = UserModel.first(username: params["username"])
      if user && user.authenticate(params["password"])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  def client_service
    @client_service ||= ClientService.new(ClientModel, TaskModel, UserModel)
  end

  def presenter
    @presenter ||= Presenter.new
  end

  get '/fun' do
    erb :fun
  end

  get '/login' do
    erb :login
  end

  post '/unauthenticated' do
    redirect '/login'
  end

  post '/login' do
    warden.authenticate!

    if warden.authenticated?
      redirect '/fun'
    else
      redirect '/login'
    end
  end

  get '/add_user' do
    warden.authenticate!
    erb :add_user
  end

  post '/add_user' do
    warden.authenticate!
    @clients = client_service.ascending_name
    client_service.tasks_by_descending_priority
    client_service.create_user(params["username"], params["password"])
    redirect '/'
  end

  get '/' do
    warden.authenticate!
    @clients = client_service.ascending_name
    client_service.tasks_by_descending_priority
    erb :home
  end

  get '/all_tasks' do
    warden.authenticate!
    @clients = client_service.ascending_name
    client_service.tasks_by_descending_priority
    erb :all_tasks
  end

  post '/complete_task' do
    warden.authenticate!
    @clients = client_service.all
    client_service.complete_task(params["client_id"], params["task_id"])
    redirect '/all_tasks'
  end

  post '/' do
    warden.authenticate!
    @clients = client_service.all
    client_service.complete_task(params["client_id"], params["task_id"])
    redirect '/'
  end

  get '/all_clients' do
    warden.authenticate!
    @clients = client_service.get_active_clients
    erb :all_clients
  end

  post '/all_clients' do
    warden.authenticate!
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_active_clients
    erb :all_clients
  end

  get '/prospects' do
    warden.authenticate!
    @clients = client_service.get_prospects
    @status = 
      erb :prospects
  end

  post '/prospects' do
    warden.authenticate!
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_prospects
    erb :prospects
  end

  get '/dormant' do
    warden.authenticate!
    @clients = client_service.get_dormant_clients
    erb :dormant
  end

  post '/dormant' do
    warden.authenticate!
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_dormant_clients
    erb :dormant
  end

  get '/add_client' do
    warden.authenticate!
    @clients = client_service.ascending_name
    erb :add_client
  end

  post '/add_client' do
    warden.authenticate!
    client_service.make_new_client(params[:new_client], params[:status])
    @clients = client_service.all
    redirect '/'
  end

  get '/add_task' do
    warden.authenticate!
    @clients = client_service.ascending_name
    erb :add_task
  end

  post '/add_task' do
    warden.authenticate!
    @clients = client_service.ascending_name
    client_service.add_task(params[:client_id], params[:task], params[:status])
    erb :home
  end

  get '/:id' do 
    warden.authenticate!
    @clients = [client_service.get_by_id(params[:id])]
    client_service.tasks_by_descending_priority
    erb :all_tasks
  end

  get '/protected' do
    warden.authenticate!
    @current_user = warden.user
    erb :protected
  end

  def warden
    env['warden']   
  end
end
