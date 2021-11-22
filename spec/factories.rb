FactoryBot.define do
    factory :usd_currency_code, class: CurrencyCode do
        code {"USD"}
        rate_last_update {2.hours.ago} 
        rate_next_update {DateTime.now}
        rate_last_update_request {1.hour.ago} 
    end

    factory :cad_currency_code, class: CurrencyCode do
        code {"CAD"}
        rate_last_update {2.hours.ago} 
        rate_next_update {DateTime.now}
        rate_last_update_request {1.hour.ago} 
    end
  end