require 'rails_helper'

RSpec.describe CurrencyCode, type: :model do
  it "is valid with valid attributes" do
    currency_code = CurrencyCode.new(
      code: "USD",
      rate_last_update: DateTime.now,
      rate_next_update: DateTime.now,
      rate_last_update_request: DateTime.now,
    )
    expect(currency_code).to be_valid
  end

  it "is not valid with no code" do
    currency_code = CurrencyCode.new(:code => nil)
    expect(currency_code).to_not be_valid
  end

  it "is not valid with non-unique code" do
    currency_code_1 = CurrencyCode.create(
      code: "USD",
      rate_last_update: DateTime.now,
      rate_next_update: DateTime.now,
      rate_last_update_request: DateTime.now,
    )
    currency_code_2 = CurrencyCode.new(
      code: "USD",
      rate_last_update: DateTime.now,
      rate_next_update: DateTime.now,
      rate_last_update_request: DateTime.now,
    )
    expect(currency_code_1).to be_valid
    expect(currency_code_2).to_not be_valid
  end
end
