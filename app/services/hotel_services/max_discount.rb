module HotelServices
  class MaxDiscount
    include Serviceable

    def initialize(user, price)
      @price = price
      @user = user
    end

    def call
      return 0.0 if @user.nil?

      coupons = @user.usable_hotel_coupons
      coupons.map { |c| c.discount_amount(@price) }.max.to_f
    end
  end
end
