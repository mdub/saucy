$LOAD_PATH << File.expand_path("../lib", __FILE__)

require "logger"

namespace :db do

  def db_manager
    require "saucy/db/manager"
    Saucy::DB::Manager.new(ENV.fetch("DATABASE_URL"), logger: Logger.new($stdout))
  end

  desc "Drop existing database"
  task :drop do
    db_manager.drop_if_exists
  end

  desc "Ensure database exists"
  task :exists do
    db_manager.create_unless_exists
  end

  desc "Run migrations"
  task :migrate, [:version] => :exists do |t, args|
    db_manager.migrate(args[:version])
  end

  desc "Open a Sequel console"
  task :console => :exists do
    require "pry"
    require "saucy/db/manager"
    require "saucy/db/event_store"
    DB = Saucy::DB.connect(ENV.fetch("DATABASE_URL"))
    ES = Saucy::DB::EventStore.new(DB)
    binding.pry
  end

end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

task "spec" => "db:migrate"

task "default" => "spec"
