source 'https://gems.ruby-china.com'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'dotenv-rails'
gem 'redis'
gem 'redis-rails'
gem 'jwt'
gem 'second_level_cache', '~> 2.3.0'
gem 'resque', github: 'resque/resque'
gem 'kaminari'
gem 'awesome_nested_set' # 多级类别

# 图片处理
gem 'carrierwave'
gem 'carrierwave-upyun'
gem 'mini_magick'

# 微信相关
gem 'weixin_authorize'
gem 'wx_pay'
gem 'wechat'

# 支付宝相关
gem 'alipay', '~> 0.15.1'

gem 'text'
gem 'harmonious_dictionary'

#  ActionStore - 一步到位的 Like, Follow, Star, Block ... 等动作的解决方案
#  https://ruby-china.org/topics/32262
gem 'action-store'

# 附近的人
gem 'geocoder'

# 极光IM gem
gem 'jmessage'

# 物流查询接口
gem 'kuaidiniao'

gem 'jpush'

gem 'rack-attack'

gem 'newrelic_rpm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot'
  gem 'database_cleaner'
  gem 'rubocop', require: false
  gem 'awesome_print'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-git-with-submodules', '~> 2.0'
  gem "capistrano-resque", "~> 0.2.2", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
