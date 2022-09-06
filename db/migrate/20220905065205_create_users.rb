class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :gov_id_number, null: false
      t.integer :gov_id_type, null: false

      t.timestamps

      t.index [:first_name, :last_name, :email, :gov_id_number, :gov_id_type],
        unique: true,
        name: :ix_users_on_first_name_last_name_email_gov_id_number_gov_id_type
    end
  end
end
