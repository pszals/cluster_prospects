require 'sinatra'
require 'bundler'
require 'data_mapper'

require_relative 'client_service'
require_relative 'client_model'
require_relative 'task_model'

DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_ROSE_URL"] || "postgres://pszalwinski: @localhost/cluster")
DataMapper.auto_upgrade!
DataMapper.finalize


class Sinatra_Cluster < Sinatra::Base
  attr_reader :params, :client_manager

  use Rack::Auth::Basic do |username, password|
    username == 'margaret' && password == 't4sktr4ck3r'
  end

  get '/' do
    @clients = client_models.ascending_name
    client_models.tasks_by_descending_priority
    erb :home
  end

  get '/all_tasks' do
    @clients = client_models.ascending_name
    client_models.tasks_by_descending_priority
    erb :all_tasks
  end

  post '/complete_task' do
    complete_task
    redirect '/all_tasks'
  end
  
  post '/' do
    complete_task
    redirect '/'
  end

  get '/add_client' do
    @clients = client_models.ascending_name
    erb :add_client
  end

  get '/all_clients' do
    @clients = client_models.ascending_name
    erb :all_clients
  end

  post '/add_client' do
    make_new_client
    @clients = client_models.all
    redirect '/'
  end

  get '/add_task' do
    @clients = client_models.ascending_name
    erb :add_task
  end
  
  post '/add_task' do
    @clients = client_models.ascending_name
    add_task
    erb :home
  end

  get '/:id' do 
    @clients = [client_models.get_by_id(params[:id])]
    client_models.tasks_by_descending_priority
    erb :all_tasks
  end

  def client_models
    @client_models ||= ClientService.new(ClientModel)
  end

  def make_new_client
    client_models.create(:name => params[:new_client].to_s)
  end

  def client_active?(client)
    if client.task_models != [] and client.task_models.all(:order => [:priority.asc]).last.priority != 0
      true
    else
      false
    end
  end

  def show_highest_priority_task(client)
    "#{client.task_models.all(:order => [:priority.asc]).last.description}"
  end

  def add_task
    client = ClientModel.get(params[:client_id])
    task = TaskModel.create(:description => params[:task], :priority => params[:priority], :client_model => client)
    task.save
  end

  def complete_task
    @clients = ClientModel.all
    client = ClientModel.get(params["client_id"].to_i)
    task = client.task_models.get(params["task_id"].to_i)
    task.update(:completed => true)
    task.update(:priority => 0)
  end
end
