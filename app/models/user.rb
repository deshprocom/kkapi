class User < ApplicationRecord
  include UserCountable

  has_one :counter, class_name: 'UserCounter'
end
