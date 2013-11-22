require 'benchmark'

module ActsAsCached
  module Benchmarking #:nodoc:
    def self.runtime=(value)
      Thread.current['memcache_runtime'] = value
    end

    def self.runtime
      Thread.current['memcache_runtime'] ||= 0.0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end

    def self.benchmark(event)
      self.runtime += event.duration
      return unless Rails.logger && Rails.logger.debug?

      Rails.logger.debug("Cache #{event.name.sub('cache_','').sub('.active_support','')} ==> #{event.payload[:key]} (#{'%.1fms' % event.duration}) #{'HIT' if event.payload[:hit]}#{'MISS' if event.payload[:miss]}")
    end
  end
end

if defined?(ActiveSupport::Notifications)
  ActiveSupport::Notifications.subscribe /cache/ do |*args|
    event =  ActiveSupport::Notifications::Event.new(*args)
    ActsAsCached::Benchmarking.benchmark(event)
  end
end

module ActsAsCached
  module MemcacheRuntime
    extend ActiveSupport::Concern
    protected

    def append_info_to_payload(payload)
      super
      payload[:memcache_runtime] = ActsAsCached::Benchmarking.runtime
      ActsAsCached::Benchmarking.reset_runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages, memcache_runtime = super, payload[:memcache_runtime]
        messages << ("Memcache: %.1fms" % memcache_runtime.to_f) if memcache_runtime
        messages
      end
    end
  end
end


