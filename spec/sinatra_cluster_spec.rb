require 'sinatra_cluster'
require 'spec_helper'
require 'data_mapper'
require_relative '../lib/client_model'
require_relative '../lib/task_model'

DataMapper.setup(:default, "postgres://pszalwinski: @localhost/learning_postgres")
DataMapper.finalize
DataMapper.auto_upgrade!

def app
  Sinatra_Cluster
end

describe Sinatra_Cluster do
   let(:cluster) { Sinatra_Cluster.new }

  describe 'cluster home page' do
    it 'retrieves a 200 response' do
      get '/'
      last_response.status.should == 200
    end
  end

  describe 'posting data to cluster' do
    it 'retrieves a 200 response' do
      post '/'
      last_response.status.should == 200
    end
  end

  describe 'viewing all tasks' do
    it 'retrieves a 200 response' do
      get '/all_tasks'
      last_response.status.should == 200
    end
  end

  describe 'completing a task' do
    it 'completes a task' do
      ClientModel.create(:name => "test task completion")
      TaskModel.create(:description => "test task completion", :client_model => ClientModel.first(:name => "test task completion"), :priority => 3)
      client_id = ClientModel.first(:name => "test task completion").id
      task_id = TaskModel.first(:description => "test task completion").id

      post '/complete_task', params={:client_id => client_id, :task_id => task_id}
      TaskModel.get(task_id).completed.should be_true

      last_response.status.should == 302
      TaskModel.first(:description => "test task completion").destroy
      ClientModel.first(:name => "test task completion").destroy
    end
  end

  describe 'viewing all clients' do
    it 'retrieves a 200 response' do
      get '/add_client'
      last_response.status.should == 200
    end
  end

  describe 'adding a client' do
    it 'creates a new client' do
      post '/add_client', params={:new_client => "Test Client from sinatra_cluster_spec.rb"}

      ClientModel.first(:name => "Test Client from sinatra_cluster_spec.rb").should_not be_nil

      last_response.status.should == 302
      ClientModel.all(:name => "Test Client from sinatra_cluster_spec.rb").destroy
    end
  end

  describe 'adding a task' do
    it 'retrieves a 200 response' do
      post '/add_task'
      last_response.status.should == 200
    end
  end
end
