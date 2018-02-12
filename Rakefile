$LOAD_PATH << File.expand_path("../lib", __FILE__)

namespace :db do

  task :drop do
    require "saucy/db/sequel"
    db_uri = URI.parse(ENV.fetch("DATABASE_URL"))
    db_name = db_uri.path[1..-1]
    root_db_uri = db_uri + "postgres"
    Sequel.connect(root_db_uri.to_s) do |db|
      if db[:pg_database].where(datname: db_name).empty?
        puts "Dropping #{db_name}"
        db.execute "DROP DATABASE #{db_name}"
      end
    end
  end

  task :exists do
    require "saucy/db/sequel"
    db_uri = URI.parse(ENV.fetch("DATABASE_URL"))
    db_name = db_uri.path[1..-1]
    root_db_uri = db_uri + "postgres"
    Sequel.connect(root_db_uri.to_s) do |db|
      if db[:pg_database].where(datname: db_name).empty?
        puts "Creating #{db_name}"
        db.execute "CREATE DATABASE #{db_name}"
      end
    end
  end

  task :console => :exists do
    sh "sequel #{ENV.fetch("DATABASE_URL")}"
  end

  desc "Run migrations"
  task :migrate, [:version] => :exists do |t, args|
    require "saucy/db/sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "lib/saucy/db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "lib/saucy/db/migrations")
    end
  end

end