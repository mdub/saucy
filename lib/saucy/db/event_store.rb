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

      attr_reader :db

      def get_commits_on(stream_id)
        []
      end

      def commit_event_on(stream_id, event)
        new_version = 1
        event_streams.insert("stream_id" => stream_id, "current_version" => new_version)
        commit = {
          "stream_id" => stream_id,
          "version" => 1,
          "event" => event
        }
        commit
      end

      private

      def event_streams
        db[:event_streams]
      end

      def event_commits
        db[:event_commits]
      end

    end

  end
end
