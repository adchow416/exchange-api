class ExchangeController < ApplicationController
    #before_action :validate_params, only: [:convert_currency]
    def currency_options
        render json: ["US", "CAN"]
    end

    def convert_currency
        puts params
        render json: 1
    end

    private

    # def validate_params
    #     params.require(:post).permit(:title, :text, :slug)
    # end
end
