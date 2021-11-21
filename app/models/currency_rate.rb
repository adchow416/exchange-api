class CurrencyRate < ActiveRecord::Base
	belongs_to :code_from, :class_name => "CurrencyCode"
  	belongs_to :code_to, :class_name => "CurrencyCode"
	
	  validates :code_from, uniqueness: { scope: :code_to }
end
