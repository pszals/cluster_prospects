require 'client/states'

class Presenter
  def client_type_selection(type)
    "<select name='status'>
      <option value=#{::Client::States::ACTIVE} #{select(type, 1)}>Active</option>
      <option value=#{::Client::States::PROSPECT} #{select(type, 2)}>Prospect</option>
      <option value=#{::Client::States::DORMANT} #{select(type, 3)}>Dormant</option>
    </select>"
  end

  def select(type, selection)
    if type == ::Client::States::ACTIVE && selection == 1
      'selected="selected"'
    elsif type == ::Client::States::PROSPECT && selection == 2
      'selected="selected"'
    elsif type == ::Client::States::DORMANT && selection == 3
      'selected="selected"'
    end
  end
end
