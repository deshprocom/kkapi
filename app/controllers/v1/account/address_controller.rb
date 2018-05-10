module V1
  module Account
    class AddressController < ApplicationController
      include UserAuthorize
      before_action :login_required
      before_action :check_params, only: [:create, :update]
      before_action :address, only: [:update, :destroy, :default]

      def index
        @addresses = @current_user.shipping_addresses
      end

      def create
        @address = @current_user.shipping_addresses.create! user_params
        reset_default(@address.id) if @address.default?
      end

      def update
        @address.update! user_params
        reset_default(@address.id) if @address.default?
        render :create
      end

      def destroy
        @address.destroy!
        render_api_success
      end

      def default
        @address.default!
        reset_default(@address.id)
        render_api_success
      end

      private

      def address
        @address = ShippingAddress.find(params[:id])
      end

      def check_params
        raise_error 'params_missing' if params[:consignee].blank? || params[:mobile].blank?
        raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(user_params[:mobile])
      end

      def reset_default(address_id)
        @current_user.shipping_addresses.where.not(id: address_id).update(default: false)
      end

      def user_params
        params.permit(:consignee,
                      :mobile,
                      :province,
                      :city,
                      :area,
                      :address,
                      :zip,
                      :default)
      end
    end
  end
end


