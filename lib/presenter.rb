require 'client/states'

class Presenter
  def client_type_selection(type)
    "<select name='status'>
      <option value=#{::Client::States::ACTIVE} #{select(type, ::Client::States::ACTIVE)}>Active</option>
      <option value=#{::Client::States::PROSPECT} #{select(type, ::Client::States::PROSPECT)}>Prospect</option>
      <option value=#{::Client::States::DORMANT} #{select(type, ::Client::States::DORMANT)}>Dormant</option>
    </select>"
  end

  def select(type, selection)
    return 'selected="selected"' if type == selection
  end
end
