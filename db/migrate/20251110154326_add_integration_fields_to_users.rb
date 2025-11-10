class AddIntegrationFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :tempo_login, :string
    add_column :users, :tempo_password_ciphertext, :text
    add_column :users, :tempo_defaults, :jsonb, default: {}, null: false
    add_column :users, :yaga_login, :string
    add_column :users, :yaga_password_ciphertext, :text
    add_column :users, :yaga_defaults, :jsonb, default: {}, null: false
    add_column :users, :otrs_login, :string
    add_column :users, :otrs_password_ciphertext, :text
  end
end
