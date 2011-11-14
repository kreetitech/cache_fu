#cache_fu

A rewrite of acts_as_cached.
This version is only compatible with rails 3 and above.

This gem version uses Dalli.
If you want a memcache compatible version then see the branch memcache_client or use version 0.1.5 of the gem.

For fragment and page caching use Rails DalliStore as it already provides all the functionality.

This gem is very useful for caching in models.

##Changes from acts_as_cached 1

* You can no longer set a 'ttl' method on a class. Instead, pass :ttl to acts_as_cached: `acts_as_cached :ttl => 15.minutes`

* The is_cached? method is aliased as cached?

* set_cache on an instance can take a ttl: `@story.set_cache(15.days)`

##Author
[Surendra Singhi](ssinghi@kreeti.com)
