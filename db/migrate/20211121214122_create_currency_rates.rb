class CreateCurrencyRates < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_rates do |t|
      t.references :code_from, null: false, foreign_key: { to_table: 'currency_codes' }
      t.references :code_to, null: false, foreign_key: { to_table: 'currency_codes' }
      t.float :rate

      t.timestamps
    end

    add_index :currency_rates, [:code_from_id, :code_to_id], unique: true
  end
end
