module UserAuthCheck
  def blocked_check!(user)
    raise_error 'account_blocked' if user.blocked?
  end

  def silenced_check!(user)
    msg = I18n.t('errors.account_silenced') + "禁言至:#{user.silence_till.strftime("%F %T")}"
    raise_error(msg, false) if user.silenced_and_till?
  end
end
