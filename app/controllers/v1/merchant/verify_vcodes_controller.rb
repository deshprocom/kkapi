module V1::Merchant
  # 校验验证码是否正确
  class VerifyVcodesController < MerchantApplicationController
    skip_before_action :login_required
    def create
      requires! :option_type, values: %w[register login]
      requires! :mobile
      requires! :vcode
      raise_error 'vcode_not_match' unless VCode.check_vcode(params[:option_type], full_mobile, params[:vcode])
      render_api_success
    end

    private

    def full_mobile
      "+#{params[:ext]}#{params[:mobile]}"
    end
  end
end
