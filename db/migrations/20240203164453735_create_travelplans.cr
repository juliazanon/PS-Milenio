class CreateTravelplans < Jennifer::Migration::Base
  def up
    create_table :travelplans do |t|

      t.timestamps
    end
  end

  def down
    drop_table :travelplans if table_exists? :travelplans
  end
end
