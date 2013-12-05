require File.dirname(__FILE__) + '/acts_as_cached/cache_methods'
require File.dirname(__FILE__) + '/acts_as_cached/benchmarking'
require File.dirname(__FILE__) + '/acts_as_cached/railtie' if defined?(Rails::Railtie)

module ActsAsCached
  @@config = {}
  mattr_reader :config

  def self.config=(options)
    @@config = options
  end

  def self.skip_cache_gets=(boolean)
    ActsAsCached.config[:skip_gets] = boolean
  end

  def self.valued_keys
    [:version, :pages, :per_page, :finder, :cache_id, :find_by, :key_size]
  end

  module Mixin
    def acts_as_cached(options = {})
      extend  ClassMethods
      include InstanceMethods

      options.symbolize_keys!

      # convert the find_by shorthand
      if find_by = options.delete(:find_by)
        options[:finder]   = "find_by_#{find_by}".to_sym
        options[:cache_id] = find_by
      end

      cache_config.replace  options.reject { |key,| not ActsAsCached.valued_keys.include? key }
      cache_options.replace options.reject { |key,| ActsAsCached.valued_keys.include? key }
    end
  end
end

# need to require after ActsAsCached.config is defined
rails_version = defined?(Rails.version) && Rails.version || defined?(Rails::VERSION::STRING) && Rails::VERSION::STRING
if rails_version && rails_version.to_f < 3
  require File.dirname(__FILE__) + '/acts_as_cached/rails'
end
