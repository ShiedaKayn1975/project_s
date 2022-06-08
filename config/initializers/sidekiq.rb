require 'sidekiq/web'
require 'sidekiq-status/web'
require 'sidekiq-scheduler/web'

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{ENV['SIDEKIQ_REDIS_HOST']}:#{ENV['SIDEKIQ_REDIS_PORT']}/#{ENV['SIDEKIQ_REDIS_DATABASE'] || 0}"
  }

  # Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
  config.on(:startup) do
    # SidekiqScheduler::Scheduler.instance.rufus_scheduler_options = { max_work_threads: 1 }
    # Sidekiq.schedule = YAML.load_file(Rails.root.join('config/sidekiq_scheduler.yml'))
    # SidekiqScheduler::Scheduler.instance.reload_schedule!

    if schedules = YAML.load_file(Rails.root.join('config/schedule.yml'))[:schedule]
      Sidekiq.schedule = schedules.select{|name, options|
        !(options['skip_on_staging'] && ENV['IS_DEV_SERVER'])
      }
      SidekiqScheduler::Scheduler.instance.reload_schedule!
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{ENV['SIDEKIQ_REDIS_HOST']}:#{ENV['SIDEKIQ_REDIS_PORT']}/#{ENV['SIDEKIQ_REDIS_DATABASE'] || 0}"
  }

  # Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
  # Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking
  ActiveSupport::SecurityUtils.secure_compare(user, ENV["SIDEKIQ_ADMIN_USER"]) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_ADMIN_PASS"])
end

# Register Redis server for redis-mutex
RedisClassy.redis = Redis.new(
  url: "redis://#{ENV['SIDEKIQ_REDIS_HOST']}:#{ENV['SIDEKIQ_REDIS_PORT']}/#{ENV['SIDEKIQ_REDIS_DATABASE'] || 0}"
)

# Get rid of warning message: Redis#exists(key)` will return an Integer in redis-rb 4.3. `exists?` returns a boolean, you should use it instead
# Redis.exists_returns_integer = false

if ENV['WITH_SCHEDULER']
else
  Sidekiq::Scheduler.enabled = false
end
