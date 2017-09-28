class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :email_confirmed, default: false
      t.string :email_confirm_token
      t.string :password_digest
      t.string :remember_digest

      t.index :email, unique: true
      t.timestamps
    end
  end
end
