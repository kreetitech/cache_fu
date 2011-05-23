begin
  require 'memcache'
rescue LoadError
end

begin
  require 'memcached'
rescue LoadError
end

begin
  require 'mem_cache_with_consistent_hashing'
rescue LoadError
end

puts "=> You should be using the `dalli' or `memcache-client' gem.  You're using RubyMemcache!" if Object.const_defined?(:RubyMemcache)

require 'cache_fu'

Object.send :include, ActsAsCached::Mixin

unless File.exists?(config_file = Rails.root.join('config', 'memcached.yml'))
  error = "No config file found.  Make sure you used `script/plugin install' and have memcached.yml in your config directory."
  puts error
  logger.error error
  exit!
end

ActsAsCached.config = YAML.load(ERB.new(IO.read(config_file)).result)

begin
  require 'extensions'
rescue LoadError
end