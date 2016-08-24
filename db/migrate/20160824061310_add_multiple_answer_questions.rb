class AddMultipleAnswerQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :multiple, :boolean, default: false
  end
end
