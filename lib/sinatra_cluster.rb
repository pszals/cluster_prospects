$LOAD_PATH.unshift File.expand_path('./', __FILE__)

require 'sinatra'
require 'sinatra/cookies'
require 'bundler'
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

  def initialize_client_manager
    @@client_manager ||= ClientManager.new
  end

  def make_new_client
    @@client_manager.new_client(params[:new_client].to_s)
  end

  def add_task
    @@client_manager.clients[params[:new_client].to_s].add_task(params[:task].to_s)
  end
end
