require "dm-types"
require "uuidtools"

module Mogok::Model

    def self.included(base)
        base.property(
            :uuid,
            DataMapper::Property::UUID,
            :key => true,
            :default => lambda { |r, p| UUIDTools::UUID.random_create }
        )
        base.property(
            :created_at,
            DataMapper::Property::EpochTime,
            :default => lambda { |r, p| Time.now }
        )
    end

end
