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

  context "a non-extant stream" do

    let(:stream_id) { SecureRandom.uuid }

    describe "#get_commits_on" do

      it "returns an empty list" do
        expect(event_store.get_commits_on("whatever").to_a).to eq([])
      end

    end

  end

end
