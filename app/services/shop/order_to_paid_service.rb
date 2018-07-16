module Shop
  class OrderToPaidService
    include Serviceable

    def initialize(order, pay_channel)
      @order = order
      @pay_channel = pay_channel
    end

    def call
      @order.status = 'paid' if @order.unpaid?
      @order.pay_status = 'paid' if @order.pay_status == 'unpaid'
      @order.pay_channel = @pay_channel
      @order.save
    end
  end
end
