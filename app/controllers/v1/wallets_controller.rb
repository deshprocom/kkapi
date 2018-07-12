module V1
  class WalletsController < ApplicationController
    include UserAuthorize
    before_action :login_required

    def account; end

    def account_details
      @details = @current_user.pocket_moneys.order(created_at: :desc).page(params[:page]).per(params[:page_size])
    end

    def withdrawal
      requires! :amount # 要提现的金额
      requires! :real_name # 要求填写真实姓名
      requires! :account_type, values: %w[alipay bank] # 提款账户类型暂时只支持支付宝和银行卡
      requires! :account # 要求填写银行卡账号
      requires! :account_memo if params[:account_type].eql?('bank') # 银行卡需要填写银行卡类型
      Services::Wallets::WithdrawalService.call(@current_user, user_params)
      render_api_success
    end

    private

    def user_params
      params.permit(:amount, :real_name, :account_type, :account, :account_memo)
    end
  end
end
