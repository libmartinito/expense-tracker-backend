class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.string :item, null: false
      t.integer :amount_in_cents, null: false
      t.string :currency, null: false
      t.datetime :purchased_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
