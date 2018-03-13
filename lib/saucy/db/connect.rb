require "sequel"

module Saucy
  module DB

    def self.connect(*args)
      Sequel.connect(*args).tap do |db|
        db.extension :pg_array, :pg_json
        yield db if block_given?
      end
    end

  end
end
