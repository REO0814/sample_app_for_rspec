require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { user = create(:user) }
  describe 'validation' do
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid
    end
    
    it 'is invalid without title' do
      task_without_title = build(:task, title: "")
      task_without_title.valid?
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end
    
    it 'is invalid without status' do
      task_without_status = build(:task, status: "")
      # task = Task.new(status: nil)
      task_without_status.valid?
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end
    
    it 'is invalid with a duplicate title' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      task_with_duplicated_title.valid?
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end
    
    it 'is valid with another title' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'another title')
      expect(task_with_another_title).to be_valid
    end
  end
end