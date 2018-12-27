module Signature
  extend ActiveSupport::Concern

  def signature_required
    authorized_error('invalid_signature') if signature_params_blank? || !signature_correct?
  end

  def signature_params_blank?
    params[:timestamp].nil? || params[:random_str].nil? || params[:signature].nil?
  end

  def generate_signature
    string = "timestamp=#{params[:timestamp]}&random_str=#{params[:random_str]}&token=desh2019"
    string_md5 = ::Digest::MD5.hexdigest(string)
    string_md5_repeat = ::Digest::MD5.hexdigest("desh#{string_md5}")
    string_md5_repeat.upcase
  end

  def signature_correct?
    generate_signature.eql? params[:signature]
  end

  def authorized_error(msg)
    raise(ApplicationController::AuthorizedError, I18n.t("errors.#{msg}"))
  end
end