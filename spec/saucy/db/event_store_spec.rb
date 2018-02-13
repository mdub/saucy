require "spec_helper"

require "saucy/db/event_store"
require "securerandom"

describe Saucy::DB::EventStore do

  let(:db) do
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end

  let(:event_store) do
    Saucy::DB::EventStore.new(db)
  end

  let(:stream_id) { SecureRandom.uuid }

  let(:stream) { event_store[stream_id] }

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

    it "has no version" do
      expect(stream.current_version).to be(nil)
    end

    it "has no commits" do
      expect(stream.commits).to be_empty
    end

  end

  context "committing some events" do

    let(:events) do
      [
        { "type" => "Increment", "by" => 11 },
        { "type" => "Increment", "by" => 22 },
        { "type" => "Clear" }
      ]
    end

    let!(:return_values) do
      events.map do |event|
        stream.commit(event)
      end
    end

    it "increments the version" do
      expect(stream.current_version).to be(3)
    end

    let(:commits) { stream.commits.to_a }

    it "stores events" do
      expect(commits.map { |c| c.fetch(:event) }).to eq(events)
    end

  end

end
