require 'uri'
require 'net/http'

class ExchangeController < ApplicationController
    # Get request that returns a list of Currency Codes that can be coverted
    # Input: None
    # Output: Array of Strings
    def currency_options
        base_code = "USD"
        code = CurrencyCode.find_by(code: base_code)
        opt = []
        if rate_not_update_required?(code)
            opt = CurrencyCode.pluck(:code)
        else
            options = get_exchange_rates(base_code)
            opt.keys
        end
        render json: opt
    end

    # Converts a given float based on a given starting currency code and a ending currency code
    # Input: userCurrency: float, userCurrencyType: string, convertedCurrencyType: string
    # Output: float
    def convert_currency
        user_currency = params["userCurrency"]
        user_currency_type = params["userCurrencyType"]
        converted_currency_type = params["convertedCurrencyType"]
        if [user_currency, user_currency_type, converted_currency_type].all?(&:present?)
            code_from = CurrencyCode.find_by(code: user_currency_type)
            code_to = CurrencyCode.find_by(code: converted_currency_type)
            if code_from.present? && code_to.present? && rate_not_update_required?(code_from)
                cur_rate = CurrencyRate.find_by(code_from: code_from, code_to: code_to)
                if cur_rate.present?
                    rate = cur_rate.rate
                    render json: user_currency.to_f * rate.to_f
                else
                    options = get_exchange_rates(user_currency_type)
                    if options.present? && options[converted_currency_type]
                        rate = options[converted_currency_type]
                        render json: user_currency.to_f * rate.to_f
                    else
                        render status: 400
                    end
                end
            else
                options = get_exchange_rates(user_currency_type)
                if options.present? && options[converted_currency_type]
                    rate = options[converted_currency_type]
                    render json: user_currency.to_f * rate.to_f
                else
                    render status: 400
                end
            end  
        else
            render status: 400
        end
        
    end

    private

    # Function that checks if a call to exchange api is needed for a given code
    # Input: CurrencyCode
    # Output: Boolean
    def rate_not_update_required?(c)
        return c.present? && c.rate_last_update_request.present? && c.rate_next_update.present? && c.rate_last_update_request < c.rate_next_update
    end

    # Function gets the exchange rates from exchange rate api
    # Input: String
    # Output: Hash
    def get_exchange_rates(code)
        url = URI.parse("https://open.er-api.com/v6/latest/#{code}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Get.new(url)
        request["x-api-key"] = ENV["SYGIC_API_KEY"]
        request["cache-control"] = 'no-cache'
        
        response = http.request(request)
        data = JSON.parse(response.body)
        rates = data["rates"]
        code_arr = []
        rates.each do|k, v|
            code_arr << {
                "code": k,
                "created_at": DateTime.now,
                "updated_at": DateTime.now
            }
        end
        CurrencyCode.upsert_all(code_arr)
        cur_code = CurrencyCode.find_by(code: code)
        cur_code.rate_last_update = DateTime.parse(data["time_last_update_utc"])
        cur_code.rate_next_update = DateTime.parse(data["time_next_update_utc"])
        cur_code.rate_last_update_request = DateTime.now
        cur_code.save
        codes = CurrencyCode.where.not(code: code)
        rate_arr = []
        codes.each do |c|
            c_rate = rates[c.code].to_f
            rate_arr << {
                "code_from_id": cur_code.id,
                "code_to_id": c.id,
                "rate": c_rate,
                "created_at": DateTime.now,
                "updated_at": DateTime.now
            }
        end
        CurrencyRate.upsert_all(rate_arr)
        return rates
    end
end
