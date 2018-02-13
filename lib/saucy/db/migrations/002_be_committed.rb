Sequel.migration do

  change do
    rename_table(:events, :event_commits)
    rename_column(:event_commits, :data, :event)
  end

end
