Sequel.migration do

  up do
    create_table(:event_streams) do
      String :stream_id, null: false, unique: true
      Integer :current_version, null: false
    end
    create_table(:events) do
      String :stream_id, null: false
      Integer :version, null: false
      json :data, null: false
      String :source
    end
  end

  down do
    drop_table(:events)
    drop_table(:event_streams)
  end

end
