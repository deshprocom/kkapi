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
      return true if !product.first_discounts

      user.shop_orders.includes(:order_items)
        .where(shop_order_items: {product_id: product.id}).exists?
    end
  end
end
