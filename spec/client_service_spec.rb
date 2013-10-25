require 'client_service'
require 'mock_db'

describe ClientService do
  let(:mock_db) {MockDB.new}
  let(:client_service) {ClientService.new(mock_db)}

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
    mock_db.should_receive(:create).with("details")
    client_service.create("details")
  end

  it 'sorts task models by descending priority if they exist' do
    mock_db.should_receive(:each)
    client_service.tasks_by_descending_priority
  end
end
