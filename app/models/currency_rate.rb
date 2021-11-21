class CurrencyRate < ActiveRecord::Base
	belongs_to :code_from, :class_name => "CurrencyCode"
  	belongs_to :code_to, :class_name => "CurrencyCode"
end
