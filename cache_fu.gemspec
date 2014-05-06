Gem::Specification.new do |s|
  s.name = 'cache_fu'
  s.version = '0.3.0'
  s.authors = ["Surendra Singhi"]
  s.summary = 'Makes caching easy for ActiveRecord models'
  s.description = "This gem is kreetitech's fork (http://github.com/kreetitech/cache_fu)."
  s.email = ['ssinghi@kreeti.com']

  s.files = Dir.glob('{lib,test,defaults}/**/*') +
                        %w(LICENSE README.md)
  s.homepage = 'http://github.com/kreetitech/cache_fu'
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '>= 2.3'
end
