module Services
  module Wallets
    class WithdrawalService
      include Serviceable

      def initialize(user, params)
        @user = user
        @params = params
        @amount = BigDecimal(@params[:amount])
      end

      def call
        check_amount
        Withdrawal.create!(init_create_params)
        @user.decrease_pocket_money(@amount)
        @user.increase_freeze_pocket_money(@amount)
      end

      def init_create_params
        { user: @user,
          real_name: @params[:real_name], # 真实姓名
          account: @params[:account], # 支付宝或银行卡账号
          account_type: @params[:account_type], # 申请提现账户类型 支付宝或微信
          account_memo: @params[:account_memo], # 银行卡需要填写银行卡类型
          amount: @amount } # 要提现的金额
      end

      # 提现限制50-1000
      def check_amount
        raise_error 'withdraw_min_limit' if @amount < 50
        raise_error 'withdraw_max_limit' if @amount > 1000
        raise_error 'withdraw_account_limit' if @user.counter.total_pocket_money < @amount
        current_month_withdraw = @amount + Withdrawal.month_success_withdraw(@user)
        raise_error 'withdraw_month_limit' if current_month_withdraw > 1000
      end
    end
  end
end
