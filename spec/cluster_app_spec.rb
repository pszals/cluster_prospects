require 'cluster_app'
require 'spec_helper'
require 'data_mapper'
require 'client_model'
require 'task_model'

DataMapper.setup(:default, "postgres://pszalwinski: @localhost/cluster")
DataMapper.finalize
DataMapper.auto_upgrade!

def app
  Sinatra_Cluster
end

describe Sinatra_Cluster do
  let(:cluster) { Sinatra_Cluster.new }
  before(:each) do
    authorize 'margaret', 't4sktr4ck3r'
  end


  describe 'adding a user page' do
    it 'retrieves a 200 response' do
      get '/add_user'
      last_response.status.should == 200
    end

    xit 'creates a new user' do
      post '/add_user', params={}
      last_response.status.should == 200
    end
  end

  describe 'cluster home page' do
    it 'retrieves a 200 response' do
      get '/'
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
      test_client = ClientModel.create(:name => "test task completion")
      TaskModel.create(:description => "test task completion", :client_model => test_client, :priority => 3)
      client_id = ClientModel.first(:name => "test task completion").id
      task_id = TaskModel.first(:description => "test task completion").id
      post '/complete_task', params={:client_id => client_id, :task_id => task_id}

      TaskModel.get(task_id).completed.should be_true
      last_response.status.should == 302

      TaskModel.all(:description => "test task completion").destroy
      ClientModel.all(:name => "test task completion").destroy
    end
  end

  describe 'viewing all clients' do
    it 'retrieves a 200 response' do
      get '/add_client'
      last_response.status.should == 200
    end
  end

  describe 'viewing all prospects' do
    it 'retrieves a 200 response' do
      get '/prospects'
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

    it 'adds client status' do
      post '/add_client', params={:new_client => "Test Client", :status => "prospect"}

      ClientModel.first(:status => "prospect").should_not be nil
      ClientModel.all(:name => "Test Client").destroy
    end
  end

  describe 'all_clients' do
    it 'modifies the status of a client' do
      ClientModel.create(:name => "Test Client")
      fake_id = ClientModel.first(:name => "Test Client").id
      post '/all_clients', params={:status => "prospect", :client_id => fake_id} 

      ClientModel.first(:id => fake_id).status.should == "prospect"
      ClientModel.all(:name => "Test Client").destroy
    end
  end

  describe 'adding a task' do
    it 'retrieves a 200 response' do
      ClientModel.create(:name => "test adding a task")
      client_id = ClientModel.first(:name => "test adding a task").id
      post '/add_task', params={:client_id => client_id, :task => "test adding a task", :priority => 3}

      last_response.status.should == 200
      TaskModel.first(:description => "test adding a task").should_not be_nil

      TaskModel.all(:description => "test adding a task").destroy
      ClientModel.all(:name => "test adding a task").destroy
    end
  end
end
