require "spec_helper"

require "saucy/db/event_store"

describe Saucy::DB::EventStore do

  let(:db) do
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end

  let(:event_store) do
    Saucy::DB::EventStore.new(db)
  end

  let(:stream) { event_store.create_stream }

  before(:each) do
    db.transaction do
      db[:event_commits].delete
      db[:event_streams].delete
    end
  end

  before(:each) do
    if ENV["DB_DEBUG"]
      db.loggers << Logger.new($stdout)
    end
  end

  context "a new stream" do

    it "has version" do
      expect(stream.current_version).to be(0)
    end

    it "has no commits" do
      expect(stream.commits).to be_empty
    end

  end

  context "a non-extant stream" do

    let(:stream) { event_store.stream("whatever") }

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
      stream.commit(*events)
    end

    it "increments the version" do
      expect(stream.current_version).to be(3)
    end

    let(:commits) { stream.commits.to_a }

    it "stores events" do
      expect(commits.map { |c| c.fetch(:event) }).to eq(events)
    end

  end

  context "committing with no events" do

    let!(:return_values) do
      stream.commit
    end

    it "sets version to 0" do
      expect(stream.current_version).to be(0)
    end

  end

  context "committing events in parallel" do

    before do
      stream.commit
      1.upto(4).map do |thread_number|
        Thread.new do
          10.times do |i|
            event = { "thread" => thread_number, "i" => i }
            stream.commit(event)
          end
        end
      end.map(&:join)
    end

    it "works as expected" do
      expect(stream.current_version).to be(40)
    end

  end

end
