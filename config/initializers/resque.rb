Resque.redis = ENV['CACHE_RESQUE_PATH']
Resque.redis.namespace = "resque:kkapi"
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.logger.level = Logger::DEBUG
puts 'after resque initialized'