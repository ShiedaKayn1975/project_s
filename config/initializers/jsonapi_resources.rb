# frozen_string_literal: true

# config/initializers/jsonapi_resources.rb:
JSONAPI.configure do |config|
  #:underscored_key, :camelized_key, :dasherized_key, or custom
  config.json_key_format = :underscored_key

  #:underscored_route, :camelized_route, :dasherized_route, or custom
  config.route_format = :underscored_key

  # built in paginators are :none, :offset, :paged
  config.default_paginator = :paged
  config.default_page_size = 25
  config.maximum_page_size = 1000

  # Do this if you use UUID's instead of Integers for id's
  # config.resource_key_type = :uuid

  # Metadata
  # Output record count in top level meta for find operation
  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count
  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :page_count

  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  # Resource caching
  config.resource_cache = Rails.cache
end

JSONAPI::Authorization.configure do |config|
  # Send context as user, will be handled in ApplicationPolicy
  config.pundit_user = ->(context){ context }
end
