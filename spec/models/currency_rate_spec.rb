require 'rails_helper'

RSpec.describe CurrencyRate, type: :model do
  it "is valid with valid attributes" do
    currency_code_1 = CurrencyCode.create(
      code: "USD",
      rate_last_update: DateTime.now,
      rate_next_update: DateTime.now,
      rate_last_update_request: DateTime.now,
    )
    currency_code_2 = CurrencyCode.create(
      code: "CAD",
      rate_last_update: DateTime.now,
      rate_next_update: DateTime.now,
      rate_last_update_request: DateTime.now,
    )
    currency_rate = CurrencyRate.new(
      :code_from => currency_code_1,
      :code_to => currency_code_2,
      :rate => '1.0'
    )
    expect(currency_rate).to be_valid
  end

  it "is not valid with no rate" do
    currency_rate = CurrencyRate.new(:rate => nil)
    expect(currency_rate).to_not be_valid
  end
end
