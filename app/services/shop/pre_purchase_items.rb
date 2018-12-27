module Shop
  class PrePurchaseItems
    attr_reader :order_items
    attr_reader :invalid_order_items
    def initialize(user, variants, province = nil)
      @user = user
      @province = Province.find_by(name: province)
      @order_items = []
      @invalid_order_items = []

      variants.to_a.each do |variant|
        discern_items(variant)
      end
    end

    def discern_items(variant)
      obj = Variant.find_by(id: variant[:id])
      return @invalid_order_items << variant[:id] if obj.nil? || obj.product.nil?

      return @invalid_order_items << obj.id unless obj.product.published?

      return @invalid_order_items << obj.id if variant[:number].to_i > obj.stock

      @order_items << OrderItem.new(variant: obj,
                                    number: variant[:number].to_i,
                                    product_id: obj.product_id)
    end

    def purchasable_check
      return '商品数量不足或已过期' if order_items.blank? && invalid_order_items.present?

      return '商品参数有误' if order_items.blank?

      order_items.each do |item|
        return '购买数量不能小于等于0' if item.number <= 0

        @able_discounts = FirstDiscountsPrice.able_discounts?(item.product, @user)
        return '首次优惠购买时，只能买一件' if @able_discounts && item.number > 1
      end

      'ok'
    end

    def check_result
      @check_result ||= purchasable_check
    end

    def total_price
      total_product_price + shipping_price
    end

    def total_product_price
      @total_product_price ||= @order_items.inject(0) do |n, item|
        price = FirstDiscountsPrice.call(item.product, @user, item.variant.price)
        (price * item.number) + n
      end
    end

    # def freight_free?
    #   # 只要有一件商品包邮，所有商品包邮
    #   @freight_free ||= @order_items.any? { |item| item.variant.product.freight_free? }
    # end

    def shipping_price
      @shipping_price ||= classified_items_by_shipping.map do |shipping, items|
        next 0.0 if shipping.free_shipping?

        shipping_method = shipping.by_code_or_default_method(@province&.province_id)
        shipping_method.freight_fee(items_calc_number(shipping, items))
      end.sum
    end

    def items_calc_number(shipping, items)
      if shipping.based_weight?
        return items.map { |item| item.variant.weight * item.number }.sum
      end

      items.map(&:number).sum
    end

    def classified_items_by_shipping
      classified_items = {}
      @order_items.each do |item|
        shipping = item.product.shipping
        if classified_items[shipping]
          classified_items[shipping] << item
        else
          classified_items[shipping] = [item]
        end
      end
      classified_items
    end

    def save_to_order(order)
      @order_items.each do |item|
        save_order_item(item, order)
        item.product.increase_sales_volume(item.number)
        item.product.one_yuan_buy&.increase_sales_volume(item.number) if @able_discounts
        item.variant.decrease_stock(item.number)

        next if item.variant.is_master?

        item.variant.product.master.decrease_stock(item.number)
      end
    end

    def save_order_item(item, order)
      item.order = order
      item.syn_variant
      item.save
    end
  end
end