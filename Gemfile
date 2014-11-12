source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rake',                    :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'serverspec',              :require => false
  gem 'puppet-lint',             :require => false
  gem 'hiera-puppet',            :require => false
  gem 'rspec', '< 2.99',         :require => false
  gem 'rspec-puppet-utils',      :require => false
  gem 'rspec-puppet',
    :git => 'https://github.com/rodjek/rspec-puppet.git',
    :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', '< 2.0.0', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
