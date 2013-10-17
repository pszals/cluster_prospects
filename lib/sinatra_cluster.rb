$LOAD_PATH.unshift File.expand_path('./', __FILE__)

require 'sinatra'
require 'bundler'
require 'data_mapper'
require_relative 'client_manager'

Bundler.require(:default)
Bundler.setup

class Sinatra_Cluster < Sinatra::Base
  attr_reader :params, :client_manager

  get '/' do
    initialize_client_manager
    @client_list = @@client_manager
    erb :home
  end

  post '/' do
    make_new_client
    add_task
    @client_list = @@client_manager
    erb :home    
  end

  get '/all_tasks' do
    @client_list = @@client_manager
    erb :all_tasks
  end

  post '/all_tasks' do
    @client_list = @@client_manager
    @@client_manager.clients.each do |client|
      client.tasks.each do |task|
        if params[task.description.underscore.to_sym] == client.name
          task.complete
        end
      end
    end
    erb :all_tasks
  end

  get '/add_client' do
    @client_list = @@client_manager
    erb :add_client
  end

  post '/add_client' do
    make_new_client
    @client_list = @@client_manager
    erb :add_client
  end

  get '/add_task' do
    @client_list = @@client_manager
    erb :add_task
  end

  post '/add_task' do
    @client_list = @@client_manager
    add_task
    erb :all_tasks
  end

  def initialize_client_manager
    @@client_manager ||= ClientManager.new
  end

  def make_new_client
    @@client_manager.new_client(params[:new_client].to_s)
  end

  def add_task
    @@client_manager.clients.each do |client|
      client.add_task(params[:task].to_s, params[:priority].to_i) if client.name == params[:new_client].to_s
    end
  end
end
