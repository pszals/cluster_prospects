require 'presenter'
require 'client/states'

describe Presenter do
  let(:presenter) {Presenter.new}
  describe "client_type_selection" do
    it "provides a template for the dropdown menu" do
      type = nil
      presenter.client_type_selection(type).should ==
        "<select name='status'>
      <option value=#{::Client::States::ACTIVE} >Active</option>
      <option value=#{::Client::States::PROSPECT} >Prospect</option>
      <option value=#{::Client::States::DORMANT} >Dormant</option>
    </select>"
    end

    it "inserts the 'selected=selected' into the correct selection" do
      type = ::Client::States::ACTIVE
      presenter.client_type_selection(type).should ==
        "<select name='status'>
      <option value=#{::Client::States::ACTIVE} selected="+'"selected"' + ">Active</option>
      <option value=#{::Client::States::PROSPECT} >Prospect</option>
      <option value=#{::Client::States::DORMANT} >Dormant</option>
    </select>"
    end

    it "inserts the 'selected=selected' into prospects" do
      type = ::Client::States::PROSPECT
      presenter.client_type_selection(type).should ==
        "<select name='status'>
      <option value=#{::Client::States::ACTIVE} >Active</option>
      <option value=#{::Client::States::PROSPECT} selected="+'"selected"' + ">Prospect</option>
      <option value=#{::Client::States::DORMANT} >Dormant</option>
    </select>"
    end

    it "inserts the 'selected=selected' into dormant" do
      type = ::Client::States::DORMANT
      presenter.client_type_selection(type).should ==
        "<select name='status'>
      <option value=#{::Client::States::ACTIVE} >Active</option>
      <option value=#{::Client::States::PROSPECT} >Prospect</option>
      <option value=#{::Client::States::DORMANT} selected="+'"selected"' + ">Dormant</option>
    </select>"
    end
  end
end
