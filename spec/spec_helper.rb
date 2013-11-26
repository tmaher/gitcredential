require 'rubygems'
require 'bundler/setup'

$: << File.dirname(__FILE__) + '/../lib'

require 'gitcredential'
require 'securerandom'

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
end
