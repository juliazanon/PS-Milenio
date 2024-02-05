class CreateTravelstops < Jennifer::Migration::Base
  def up
    create_table :travel_stops do |t|
      t.string :name, {:null => false}
      t.string :type, {:null => false}
      t.string :dimension, {:null => false}

      t.timestamps
    end
  end

  def down
    drop_table :travel_stops if table_exists? :travel_stops
  end
end
