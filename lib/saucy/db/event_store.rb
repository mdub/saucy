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
        commits(stream_id).order(:version).map do |commit|
          commit[:event] = JSON.load(commit[:event])
          commit
        end
      end

      def current_version_of(stream_id)
        stream(stream_id).get(:current_version)
      end

      def commit_event_on(stream_id, event)
        version = current_version_of(stream_id)
        if version
          version += 1
          stream(stream_id).update(:current_version => version)
        else
          version = 1
          db[:event_streams].insert(:stream_id => stream_id, :current_version => version)
        end
        event = Sequel.pg_json(event)
        commit = {
          :stream_id => stream_id,
          :version => version,
          :event => event
        }
        commits(stream_id).insert(:stream_id => stream_id, :version => version, :event => event)
        commit
      end

      private

      def stream(id)
        db[:event_streams].where(:stream_id => id)
      end

      def commits(id)
        db[:event_commits].where(:stream_id => id)
      end

    end

  end
end
