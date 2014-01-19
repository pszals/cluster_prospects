require 'data_mapper_wrapper'
require 'data_mapper'
require 'bcrypt'
require 'warden'
require 'mock_db'
require 'user_model'
require 'spec_helper'
require 'client_model'

describe DataMapperWrapper do
  let(:clients) {MockDB.new}
  let(:tasks) {MockDB.new}
  let(:client_service) {DataMapperWrapper.new(clients, tasks, UserModel)}

  it 'responds to all' do
    clients.should_receive(:all).with(:user_model_id => 11)
    client_service.all(11)
  end

  it 'responds to sorted_ascending_priority' do
    clients.should_receive(:all).with(:order => [:priority.asc], :user_model_id => 11)
    client_service.ascending_priority(11)
  end

  it 'responds to sorted_descending_priority' do
    clients.should_receive(:all).with(:order => [:priority.desc], :user_model_id => 11)
    client_service.descending_priority(11)
  end

  it 'responds to sorted_ascending_name' do
    clients.should_receive(:all).with(:order => [:name.asc], :user_model_id => 11)
    client_service.ascending_name(11)
  end

  it 'makes a new client' do
    clients.should_receive(:create).with({name: "name", status: "status", user_model_id: 1})
    client_service.make_new_client("name", "status", 1)
  end

  it 'gets client by id' do
    clients.should_receive(:get)
    client_service.get_by_id(3)
  end

  it 'gets prospective clients' do
    clients.should_receive(:all).with(:order => [:name.asc], :status => "prospect", :user_model_id => 11)
    client_service.get_prospects(11)
  end

  it 'gets active clients' do
    clients.should_receive(:all).with(:order => [:name.asc], :status => "active", :user_model_id => 11)
    clients.should_receive(:all).with(:order => [:name.asc], :status => nil, :user_model_id => 11)
    client_service.get_active_clients(11)
  end

  it 'gets dormant clients' do
    clients.should_receive(:all).with(:order => [:name.asc], :status => "dormant", :user_model_id => 11)
    client_service.get_dormant_clients(11)
  end

  it 'adds a user to the database' do

    client_service.create_user("fake", "password")

    UserModel.first(:username => "fake").should_not be_nil
    UserModel.all(:username => "fake").destroy
  end

  it 'fetches users by username' do
    UserModel.should_receive(:first).with(username: "admin")
    client_service.find_by_username("admin")
  end

  it 'fetches all clients belonging to a given user' do
    test_user = UserModel.first(username: "admin")
    test_client = 

    test_users_clients = client_service.get_clients_for_user(test_user) 

    test_users_clients.should_not be_nil
  end
end
