class MerchantApplicationController < BaseApplicationController
  include MerchantUserAuthorize
  before_action :login_required
end
