require 'rails_helper'

RSpec.describe "ExchangeControllers", type: :request do
  describe "GET /currency_options" do
    before(:each) do
      stub_request(:get, "https://open.er-api.com/v6/latest/USD").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Cache-Control'=>'no-cache',
       'Host'=>'open.er-api.com',
       'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: {
        "time_last_update_unix":1637452952,"time_last_update_utc":"Sun, 21 Nov 2021 00:02:32 +0000",
        "time_next_update_unix":1637541342,"time_next_update_utc":"Mon, 22 Nov 2021 00:35:42 +0000",
        "time_eol_unix":0,
        "base_code":"USD",
        "rates":{"USD":1,"CAD":3.67}
      }.to_json, headers: {})
    end
    
    it "returns a list of currency codes when there are cached values" do
      FactoryBot.create(:usd_currency_code)
      get '/currency_options'
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end

    it "returns a list of currency codes when there are no cached values" do
      get '/currency_options'
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end
  end

  describe "GET /convert_currency" do
    before(:each) do
      usd = FactoryBot.create(:usd_currency_code)
      cad = FactoryBot.create(:cad_currency_code)
      CurrencyRate.create(
        :code_from => usd,
        :code_to => cad,
        :rate => '2.0'
      )
    end

    it "returns a rate that is converted" do
      get '/convert_currency?userCurrency=1&userCurrencyType=USD&convertedCurrencyType=CAD'
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to be_empty
    end

    it "returns an error when missing parameters" do
      get '/convert_currency'
      expect(response).to have_http_status(400)
    end
  end
end
