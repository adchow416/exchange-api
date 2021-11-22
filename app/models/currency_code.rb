class CurrencyCode < ActiveRecord::Base
    has_many :rate_from, class_name: "CurrencyRate", foreign_key: "code_from_id"
    has_many :rate_to, class_name: "CurrencyRate", foreign_key: "code_to_id"
    validates :code, uniqueness: true
    validates_presence_of :code
end
