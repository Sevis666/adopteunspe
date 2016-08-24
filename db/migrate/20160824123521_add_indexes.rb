class AddIndexes < ActiveRecord::Migration
  def change
    add_index :answers, :question_id
    add_index :votes, :question_id
    add_index :suggested_coeffs, :question_id
  end
end
