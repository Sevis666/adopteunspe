class AddGodfather < ActiveRecord::Migration
  def change
    add_column :users, :godfather_id, :integer
    add_column :spes, :elligible, :boolean, default: true
  end
end
