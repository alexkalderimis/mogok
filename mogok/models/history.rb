require "dm-is-versioned"

class History

    include DataMapper::Resource
    include Mogok::Model

    property :name, String
    property :deleted_at, ParanoidDateTime
    property :updated_at, DateTime
    property :revision, Integer, :default => 0

    has n, :steps
    belongs_to :user

    is :versioned, :on => :revision

    before :save do
        self.updated_at = Time.now
        self.revision = self.revision + 1
    end

    def rollback(version)
        v_attrs = version.attributes.reject {|k, v| k == :revision }
        update v_attrs
    end

end

