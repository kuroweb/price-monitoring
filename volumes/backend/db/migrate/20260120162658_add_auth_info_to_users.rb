class AddAuthInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email, :string, null: false, default: ""
    add_column :users, :provider_name, :string, null: false, default: ""
    add_column :users, :provider_uid, :string, null: false, default: ""

    add_index :users, %i[provider_name provider_uid], unique: true
    add_index :users, :email
  end
end
