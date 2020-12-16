require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { user = FactoryBot.create(:user) }
  describe 'validation' do
    it 'is valid with all attributes' do
      task = Task.new(
        title: 'test',
        content: 'test content',
        status: 0,
        deadline: Date.current.in_time_zone,
        user: user
      )
      expect(task).to be_valid
    end
    
    it 'is invalid without title' do
      task = Task.new(title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end
    
    it 'is invalid without status' do
      task = Task.new(status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end
    
    it 'is invalid with a duplicate title' do
      task = FactoryBot.create(:task)
      other_task = Task.new(
        title: 'title',
        content: 'content',
        status: 0,
        user: user
      )
      other_task.valid?
      expect(other_task.errors[:title]).to include("has already been taken")
    end
    
    it 'is valid with another title' do
      task = FactoryBot.create(:task)
      other_task = Task.new(
        title: 'another title',
        content: 'content',
        status: 0,
        user: user
      )
      expect(other_task).to be_valid
    end
  end
end