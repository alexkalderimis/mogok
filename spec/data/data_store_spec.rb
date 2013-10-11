require 'rspec'

require 'mogok/data'
require 'dm-migrations'

describe Mogok::DataStore, '#histories' do

    DB = { :mogok => 'postgres://alex:alex@localhost/mogok-test' }
    DUMMY = {:username => "dummy", :password => "passw0rd"}
    #'sqlite::memory' }

    def dummy_user
        @data_store.create_user DUMMY[:username], DUMMY[:password]
    end

    before :all do
        Mogok::DataStore.init :db => DB
    end

    before :each do
        DataMapper.auto_migrate!
        @data_store = Mogok::DataStore.connect
    end

    it 'is possible to add a user' do
        u = @data_store.create_user("me", "not a good password")
        expect(u.username).to eq("me")
        expect(u.password).to eq("not a good password")
    end

    it 'is possible to retrieve a user' do
        @data_store.create_user("me", "not a good password")
        u = @data_store.get_user("me")
        expect(u.password).to eq("not a good password")
    end
    

    it 'starts out with no histories' do
        expect(@data_store.histories).to be_empty
    end

    it 'adds histories when we ask' do
        u = dummy_user
        3.times { @data_store.add_history :user => u }
        hs = @data_store.histories
        expect(hs.size).to eq(3)
    end

    it 'creates histories that have no steps' do
        h = @data_store.add_history :user => dummy_user
        expect(h.steps).to be_empty
    end

    it 'is possible to add steps to a history' do
        h = @data_store.add_history :user => dummy_user
        expect(h.steps).to be_empty
        s = h.steps.new
        h.save
        hh = @data_store.get_history h.uuid
        expect(hh.steps).not_to be_empty
    end

    it 'is possible to delete a history' do
        h = @data_store.add_history :user => dummy_user
        expect(@data_store.histories).not_to be_empty
        h.destroy
        expect(@data_store.histories).to be_empty
    end

    it 'is possible to rollback a versioned history' do
        h = @data_store.add_history :user => dummy_user, :name => "V1"

        hh = @data_store.get_history(h.uuid)
        hh.name.should == "V1"
        hh.update :name => "V2"

        hhh = @data_store.get_history(h.uuid)
        hhh.name.should == "V2"
        expect(hhh.versions).not_to be_empty

        hhh.rollback(hhh.versions.first)

        @data_store.get_history(h.uuid).name.should == "V1"
        @data_store.get_history(h.uuid).revision.should == 3
    end

    it 'is possible to restore a deleted history' do
        h = @data_store.add_history :user => dummy_user
        uuid = h.uuid
        expect(@data_store.histories).not_to be_empty

        h.destroy
        expect(@data_store.histories).to be_empty

        @data_store.restore_history(uuid)
        expect(@data_store.histories).not_to be_empty
    end

end
