require "rspec"

require "saucy/db/event_store"
require "securerandom"

describe Saucy::DB::EventStore do

  let(:db) do
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end

  let(:event_store) do
    Saucy::DB::EventStore.new(db)
  end

  around(:each) do |example|
    db.transaction do
      example.run
      raise Sequel::Rollback
    end
  end

  before(:each) do
    if ENV["DB_DEBUG"]
      db.loggers << Logger.new($stdout)
    end
  end

  context "a non-extant stream" do

    let(:stream_id) { SecureRandom.uuid }

    describe "#get_commits_on" do

      it "returns an empty list" do
        expect(event_store.get_commits_on("whatever").to_a).to eq([])
      end

    end

    describe "#commit_event_on" do

      let(:event) { {"foo" => "bar"} }

      let!(:result) { event_store.commit_event_on(stream_id, event) }

      it "adds a row to event_streams" do
        event_stream_entry = db[:event_streams].where(:stream_id => stream_id).first!
        expect(event_stream_entry).to include(:stream_id => stream_id, :current_version => 1)
      end

      it "returns the new version number" do
        expect(result.fetch(:version)).to eq(1)
      end

    end

  end

  context "after committing some events" do

    let(:stream_id) { SecureRandom.uuid }

    let(:events) do
      [
        { "type" => "Increment", "by" => 11 },
        { "type" => "Increment", "by" => 22 },
        { "type" => "Clear" }
      ]
    end

    before do
      events.each do |event|
        event_store.commit_event_on(stream_id, event)
      end
    end

    describe "#current_version" do

      it "returns the version of the last event" do
        expect(event_store.current_version_of(stream_id)).to eq(3)
      end

    end

  end

end
