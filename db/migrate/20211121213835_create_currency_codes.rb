class CreateCurrencyCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_codes do |t|
      t.string :code
      t.datetime :rate_last_update
      t.datetime :rate_next_update
      t.datetime :rate_last_update_request

      t.timestamps
    end
  end
end
