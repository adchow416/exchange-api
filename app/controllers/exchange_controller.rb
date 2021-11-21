require 'uri'
require 'net/http'

class ExchangeController < ApplicationController
    def currency_options
        options = get_exchange_rates("USD")
        render json: options.keys
    end

    def convert_currency
        user_currency = params["userCurrency"]
        user_currency_type = params["userCurrencyType"]
        converted_currency_type = params["convertedCurrencyType"]
        if [user_currency, user_currency_type, converted_currency_type].all?(&:present?)
            render json: 1
        else
            render status: 400
        end
    end

    private
    
    def get_exchange_rates(code)
        url = URI.parse("https://open.er-api.com/v6/latest#{c}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Get.new(url)
        request["x-api-key"] = ENV["SYGIC_API_KEY"]
        request["cache-control"] = 'no-cache'
        
        response = http.request(request)
        data = JSON.parse(response.body)
        return data["rates"]
    end
end
