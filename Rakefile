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
    sh "sequel #{ENV.fetch("DATABASE_URL")}"
  end

end