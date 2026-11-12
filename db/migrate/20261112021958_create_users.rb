class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.integer :credits, null: false, default: 100

      t.timestamps
    end

    add_check_constraint :users, "credits >= 0", name: "users_credits_non_negative"
  end
end
