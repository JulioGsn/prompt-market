class CreateAcquisitions < ActiveRecord::Migration[8.1]
  def change
    create_table :acquisitions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_id, null: false
      t.integer :paid_price, null: false

      t.timestamps
    end

    add_check_constraint :acquisitions, "paid_price > 0", name: "acquisitions_paid_price_positive"
    add_index :acquisitions, %i[user_id product_id], unique: true
  end
end
