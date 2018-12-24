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
    string_base64 = Base64.strict_encode64(string)
    string_md5 = ::Digest::MD5.hexdigest(string_base64)
    string_md5.upcase
  end

  def signature_correct?
    generate_signature.eql? params[:signature]
  end

  def authorized_error(msg)
    raise(ApplicationController::AuthorizedError, I18n.t("errors.#{msg}"))
  end
end