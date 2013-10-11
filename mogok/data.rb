require "rubygems"
require "data_mapper"
require "uuidtools"

module Mogok

    class DataStore

        @@initialised = false

        def self.init(settings)
            return if @@initialised
            DataMapper.setup(:default, settings[:db][:mogok])
            require "mogok/model"
            require "mogok/models/user"
            require "mogok/models/step"
            require "mogok/models/history"
            DataMapper::Model.raise_on_save_failure = true
            DataMapper.finalize
            @@initialised = true
        end

        def self.connect
            DataStore.new
        end

        def histories
            History.all
        end

        def get_history(uuid)
            History.get(uuid)
        end

        def add_history(attrs = {})
            History.create(attrs)
        end

        def restore_history(uuid)
            h = History.with_deleted { History.get uuid }
            h.deleted_at = nil
            h.save
            return h
        end

        def create_user(username, password)
            u = User.new(:username => username)
            u.password = password
            u.save
            return u
        end

        def get_user(username)
            User.first(:username => username)
        end

    end
end
