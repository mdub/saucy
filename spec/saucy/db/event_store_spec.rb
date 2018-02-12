require "rspec"

require "saucy/db/event_store"

describe Saucy::DB::EventStore do

  let(:event_store) do
    Saucy::DB::EventStore.from_url(ENV.fetch("DATABASE_URL"))
  end

  context "new stream" do

    describe "#get_events_for" do
      it "returns an empty list" do
        expect(event_store.get_events_for("whatever").to_a).to eq([])
      end
    end

  end

end
