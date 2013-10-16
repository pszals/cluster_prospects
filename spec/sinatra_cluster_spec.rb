require 'sinatra_cluster'
require 'spec_helper'

def app
  Sinatra_Cluster
end

describe Sinatra_Cluster do
 # let(:cluster) { Sinatra_Cluster.new }

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
    it 'retrieves a 200 response' do
      post '/all_tasks'
      last_response.status.should == 200
    end
  end
end
