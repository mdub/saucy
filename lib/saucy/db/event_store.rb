require "logger"
require "saucy/db/setup"
require "uri"

module Saucy
  module DB

    # An RDBMS-backed event store
    #
    class EventStore

      def initialize(db)
        @db = db
      end

      def get_commits_on(stream_id)
        []
      end

    end

  end
end
