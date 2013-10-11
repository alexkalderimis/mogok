require "rubygems"

require "sinatra/base"
require "sinatra/config_file"
require "sinatra/respond_with"
require "sinatra/cross_origin"
require "haml"
require "json"
require "multi_json"


module Mogok 
    class Server < Sinatra::Base

        register Sinatra::ConfigFile
        register Sinatra::RespondWith
        register Sinatra::CrossOrigin

        config_file "config.yml"

        configure :development do
            enable :logging
        end

        get "/" do
            haml :index
        end

        run! if app_file == $0
    end
end

