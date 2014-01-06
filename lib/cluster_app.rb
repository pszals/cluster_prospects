$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'bundler'
require 'data_mapper'
require 'client_service'
require 'client_model'
require 'task_model'
require 'presenter'

DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_ROSE_URL"] || "postgres://pszalwinski: @localhost/cluster")
DataMapper.auto_upgrade!
DataMapper.finalize

class Sinatra_Cluster < Sinatra::Base
  attr_reader :params

  use Rack::Auth::Basic do |username, password|
    username == 'margaret' && password == 't4sktr4ck3r'
  end

  def client_service
    @client_service ||= ClientService.new(ClientModel, TaskModel)
  end

  def presenter
    @presenter ||= Presenter.new
  end

  get '/' do
    @clients = client_service.ascending_name
    client_service.tasks_by_descending_priority
    erb :home
  end

  get '/all_tasks' do
    @clients = client_service.ascending_name
    client_service.tasks_by_descending_priority
    erb :all_tasks
  end

  post '/complete_task' do
    @clients = client_service.all
    client_service.complete_task(params["client_id"], params["task_id"])
    redirect '/all_tasks'
  end
  
  post '/' do
    @clients = client_service.all
    client_service.complete_task(params["client_id"], params["task_id"])
    redirect '/'
  end

  get '/all_clients' do
    @clients = client_service.get_active_clients
    erb :all_clients
  end

  post '/all_clients' do
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_active_clients
    erb :all_clients
  end

  get '/prospects' do
    @clients = client_service.get_prospects
    @status = 
    erb :prospects
  end

  post '/prospects' do
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_prospects
    erb :prospects
  end

  get '/dormant' do
    @clients = client_service.get_dormant_clients
    erb :dormant
  end

  post '/dormant' do
    client_service.update_client_status(params["client_id"].to_i, params[:status])
    @clients = client_service.get_dormant_clients
    erb :dormant
  end

  get '/add_client' do
    @clients = client_service.ascending_name
    erb :add_client
  end

  post '/add_client' do
    client_service.make_new_client(params[:new_client], params[:status])
    @clients = client_service.all
    redirect '/'
  end

  get '/add_task' do
    @clients = client_service.ascending_name
    erb :add_task
  end
  
  post '/add_task' do
    @clients = client_service.ascending_name
    client_service.add_task(params[:client_id], params[:task], params[:status])
    erb :home
  end

  get '/:id' do 
    @clients = [client_service.get_by_id(params[:id])]
    client_service.tasks_by_descending_priority
    erb :all_tasks
  end
end
