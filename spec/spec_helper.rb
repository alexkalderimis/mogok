require 'rubygems'
require 'spork' # test forking

ENV['RACK_ENV'] = 'test'

Spork.prefork do

    require File.join(File.dirname(__FILE__), '..', 'mogok.rb')

    require 'rubygems'
    require 'sinatra'
    require 'rspec'
    require 'rack/test'
    require 'capybara'
    require 'capybara/dsl'

    Capybara.app = Mogok::Server

    set :environment, :test
    set :run, :false
    set :raise_errors, true
    set :logging, false

    RSpec.configure do |conf|
        conf.include Rack::Test::Methods
        conf.include Capybara::DSL
    end

    def app
        @app ||= Mogok::Server
    end
end

Spork.each_run do
end
