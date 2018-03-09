require "logger"
require "saucy/db/connect"
require "uri"

module Saucy
  module DB

    class Manager

      def initialize(uri, logger: Logger.new(nil))
        @db_uri = URI(uri)
        @logger = logger
      end

      attr_reader :db_uri
      attr_reader :logger

      def db_name
        db_name = db_uri.path[1..-1]
      end

      def pg_admin_uri
        db_uri + "postgres"
      end

      def drop_if_exists
        Saucy::DB.connect(pg_admin_uri.to_s) do |db|
          unless db[:pg_database].where(datname: db_name).empty?
            logger.info("Dropping database #{db_name}")
            db.execute "DROP DATABASE #{db_name}"
          end
        end
      end

      def create_unless_exists
        Saucy::DB.connect(pg_admin_uri.to_s) do |db|
          if db[:pg_database].where(datname: db_name).empty?
            yield db_name if block_given?
            logger.info("Creating database #{db_name}")
            db.execute "CREATE DATABASE #{db_name}"
          end
        end
      end

      def migrate(version = nil)
        migration_dir = File.expand_path("../migrations", __FILE__)
        Sequel.extension :migration
        Saucy::DB.connect(db_uri.to_s) do |db|
          if version
            logger.info "Migrating to version #{version}"
            Sequel::Migrator.run(db, migration_dir, target: Integer(version))
          else
            logger.info "Migrating to latest"
            Sequel::Migrator.run(db, migration_dir)
          end
        end
      end
    end

  end
end