# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-keystone/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Don Bowman"]
  gem.email         = ["don.waterloo@gmail.com"]
  gem.description   = %q{OmniAuth strategy for OpenStack keystone}
  gem.summary       = %q{OmniAuth strategy for OpenStack keystone}
  gem.homepage      = "https://github.com/donbowman/omniauth-keystone"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-keystone"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Keystone::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'openstack'
end
