class AddAdminTokens < ActiveRecord::Migration
  def change
    add_column :spes, :admin_token, :string
  end
end
