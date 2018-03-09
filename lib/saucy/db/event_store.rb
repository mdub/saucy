require "logger"
require "securerandom"
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

      def create_stream
        stream(SecureRandom.uuid).create
      end

      def stream(id)
        Stream.new(id: id, db: db)
      end

      def [](id)
        stream(id)
      end

      class Stream

        def initialize(id:, db:)
          @id = id
          @db = db
        end

        attr_reader :db
        attr_reader :id

        def create
          db[:event_streams].insert(:stream_id => id, :current_version => 0)
          self
        end

        def current_version
          db[:event_streams].where(:stream_id => id).for_update.get(:current_version)
        end

        def commit(*events)
          db.transaction do
            version = current_version
            commits = events.map do |event|
              version += 1
              commit = {
                :stream_id => id,
                :version => version,
                :event => Sequel.pg_json(event)
              }
              db[:event_commits].insert_select(commit)
            end
            db[:event_streams].where(:stream_id => id).update(:current_version => version)
            commits
          end
        end

        def commits
          db[:event_commits].where(:stream_id => id).order(:version).map do |commit|
            commit[:event] = commit[:event]
            commit
          end
        end

      end

    end

  end
end
