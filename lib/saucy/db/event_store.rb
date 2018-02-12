require "logger"
require "saucy/db/setup"
require "uri"

module Saucy
  module DB

    # An RDBMS-backed event store
    #
    class EventStore

      def self.from_url(database_url)
        new(Sequel.connect(database_url))
      end

      def initialize(db)
        @db = db
      end

      def get_events_for(stream_id)
        []
      end

    end

  end
end
