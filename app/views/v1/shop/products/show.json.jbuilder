json.partial! 'common/basic', api_result: ApiResult.success_result

# data
json.data do # rubocop:disable Metrics/BlockLength
  json.product do
    json.id              @product.id
    json.category_id     @product.category_id
    json.title           @product.title
    json.intro           @product.intro
    json.icon            @product.preview_icon
    json.first_discounts @product.first_discounts
    json.price           Shop::FirstDiscountsPrice.call(@product, @current_user)
    json.description     @product.description
    json.returnable      @product.returnable
    json.freight_fee     @product.shipping.default_freight_fee(@product).to_s

    json.master do
      json.partial! 'variant', variant: @product.master
    end

    json.variants do
      json.array! @product.variants, partial: 'variant', as: :variant
    end

    json.has_variants @product.variants.present?
    json.option_types do
      json.partial! 'option_types', product: @product
    end

    json.images do
      json.array! @product.images do |image|
        json.id      image.id
        json.preview image.preview
        json.large   image.large
      end
    end
  end
end