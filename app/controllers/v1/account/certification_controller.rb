module V1
  module Account
    class CertificationController < ApplicationController
      CERT_TYPES = %w[chinese_id passport_id].freeze
      ID_REGEX = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
      REAL_NAME_REGEX = /^[A-z]+$|^[\u4E00-\u9FA5]+$/

      include UserAuthorize
      before_action :login_required
      before_action :check_params, only: [:create, :update]
      before_action :set_certification, only: [:update, :destroy, :default]

      def index
        @certs = @current_user.user_extras.group_by(&:cert_type)
      end

      def create
        @api_result = Services::Account::CertificationService.call(@current_user, user_params)
      end

      def update
        @api_result = Services::Account::CertificationService.call(@current_user, user_params, @certification)
        render :create
      end

      def destroy
        @certification.soft_delete
        render_api_success
      end

      def default
        @certification.default!
        reset_default(@certification.id)
        render_api_success
      end

      private

      def user_params
        params.permit(:real_name,
                      :cert_no,
                      :cert_type,
                      :image)
      end

      def set_certification
        @certification = UserExtra.find(params[:id])
      end

      def reset_default(extra_id)
        @current_user.user_extras.where.not(id: extra_id).update(default: false)
      end

      def check_params
        requires! :real_name
        requires! :cert_no
        optional! :cert_type, values: CERT_TYPES
      end
    end
  end
end
