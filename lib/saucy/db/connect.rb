require "sequel"

module Saucy
  module DB

    def self.connect(*args)
      Sequel.connect(*args).tap do |db|
        db.extension :pg_array, :pg_json
      end
    end

  end
end
