require 'client_service'
require 'data_mapper'
require 'bcrypt'
require 'warden'
require 'mock_db'
require 'user_model'
require 'spec_helper'
require 'client_model'

describe ClientService do
  let(:mock_db) {MockDB.new}
  let(:client_service) {ClientService.new(mock_db, mock_db, UserModel)}

  it 'responds to all' do
    mock_db.should_receive(:all)
    client_service.all
  end

  it 'responds to sorted_ascending_priority' do
    mock_db.should_receive(:all).with(:order => [:priority.asc])
    client_service.ascending_priority
  end

  it 'responds to sorted_descending_priority' do
    mock_db.should_receive(:all).with(:order => [:priority.desc])
    client_service.descending_priority
  end

  it 'responds to sorted_ascending_name' do
    mock_db.should_receive(:all).with(:order => [:name.asc])
    client_service.ascending_name
  end

  it 'makes a new client' do
    mock_db.should_receive(:create).with({:name=>"name", :status=>"status"})
    client_service.make_new_client("name", "status")
  end

  it 'sorts task models by descending priority if they exist' do
    mock_db.should_receive(:each)
    client_service.tasks_by_descending_priority
  end

  it 'gets client by id' do
    mock_db.should_receive(:get)
    client_service.get_by_id(3)
  end

  it 'gets prospective clients' do
    mock_db.should_receive(:all).with(:order => [:name.asc], :status => "prospect")
    client_service.get_prospects
  end

  it 'gets active clients' do
    mock_db.should_receive(:all).with(:order => [:name.asc], :status => "active")
    mock_db.should_receive(:all).with(:order => [:name.asc], :status => nil)
    client_service.get_active_clients
  end

  it 'gets dormant clients' do
    mock_db.should_receive(:all).with(:order => [:name.asc], :status => "dormant")
    client_service.get_dormant_clients
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
