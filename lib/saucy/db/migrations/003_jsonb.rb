Sequel.migration do

  up do
    set_column_type(:event_commits, :event, :jsonb)
  end

  down do
    set_column_type(:event_commits, :event, :json)
  end

end
