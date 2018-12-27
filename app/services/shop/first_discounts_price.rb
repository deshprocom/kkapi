module Shop
  class FirstDiscountsPrice
    include Serviceable

    def self.call(product, user, price = nil)
      price = price ? price : product.master.price
      return price if user.nil?

      first_exists = first_buy_exists?(product, user)

      return price if first_exists

      1.to_d
    end

    def self.first_buy_exists?(product, user)
      # 如果商品不支持首次购买优惠，则默认已经存在首次购买的记录
      return true unless product.one_yuan_buy

      return true unless product.one_yuan_buy.discounts_valid?

      user.shop_orders.includes(:order_items)
        .where.not(status: 'canceled')
        .where(shop_order_items: {product_id: product.id}).exists?
    end

    def self.able_discounts?(product, user)
      return false if user.nil?

      !first_buy_exists?(product, user)
    end
  end
end
