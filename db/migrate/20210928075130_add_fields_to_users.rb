class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uuid, :string
    add_column :users, :provider, :string
    add_column :users, :image, :string
  end
end
