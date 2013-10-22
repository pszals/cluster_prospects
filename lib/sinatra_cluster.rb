$LOAD_PATH.unshift File.expand_path('./', __FILE__)

require 'sinatra'
require 'bundler'
require 'data_mapper'
require_relative 'client_model'
require_relative 'task_model'



DataMapper.setup(:default, "postgres://pszalwinski: @localhost/learning_postgres")
DataMapper.finalize
DataMapper.auto_upgrade!

class Sinatra_Cluster < Sinatra::Base
  attr_reader :params, :client_manager

  get '/' do
    @clients = ClientModel.all(:order => [:name.asc]) 
    @clients.each do |client|
      client.task_models.all(:order => [:priority.asc]) if client.task_models != []
    end
    erb :home
  end

  post '/' do
    @clients = ClientModel.all
    erb :home    
  end

  get '/all_tasks' do
    @clients = ClientModel.all(:order => [:name.asc]) 
    @clients.each do |client|
      client.task_models.all(:order => [:priority.desc]) if client.task_models != []
    end
    erb :all_tasks
  end

  post '/complete_task' do
    complete_task
    redirect '/all_tasks'
  end

  get '/add_client' do
    @clients = ClientModel.all(:order => [:name.asc]) 
    erb :add_client
  end

  post '/add_client' do
    make_new_client
    @clients = ClientModel.all
    redirect '/'
  end

  get '/add_task' do
    @clients = ClientModel.all(:order => [:name.asc]) 
    erb :add_task
  end
  
  post '/add_task' do
    @clients = ClientModel.all(:order => [:name.asc]) 
    add_task
    erb :all_tasks
  end

  def make_new_client
    ClientModel.create(:name => params[:new_client].to_s)
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
