module V1::Merchant
  class VCodesController < MerchantApplicationController
    skip_before_action :login_required
    SMS_TEMPLATE = '【澳门旅行APP】您的验证码是：%s，请不要把验证码泄漏给其他人。'.freeze

    def create
      requires! :option_type, values: %w[register login]
      requires! :mobile
      check_permission

      raise_error 'mobile_format_error' unless UserValidator.mobile_valid?(params[:mobile], params[:ext])
      vcode = VCode.generate_mobile_vcode(params[:option_type], "+#{params[:ext]}#{params[:mobile]}")
      sms_content = format(SMS_TEMPLATE, vcode)
      Rails.logger.info "send [#{sms_content}] to #{params[:mobile]} in queue"

      # 测试则不实际发出去
      return render_api_success if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?

      SendMobileIsmsJob.perform_later(params[:mobile], sms_content, ext: params[:ext])
      render_api_success
    end

    private

    def check_permission
      raise_error 'user_already_exist' if params[:option_type].eql?('register') && MerchantUser.mobile_exist?(params[:mobile])
      raise_error 'user_not_found' if params[:option_type].eql?('login') && !MerchantUser.mobile_exist?(params[:mobile])
    end
  end
end
