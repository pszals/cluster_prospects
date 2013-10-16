require 'task'

describe Task do
  let(:task) {Task.new}
  it 'has a priority' do
    task.priority = 2
    task.priority.should == 2
  end

  it 'has a description' do
    task.description = "no hitting"
    task.description.should == "no hitting"
  end

  it 'can be completed' do
    task.completed.should == false

    task.complete

    task.completed.should == true
    task.priority.should == 0
  end
end
