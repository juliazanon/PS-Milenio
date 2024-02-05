class CreateTravelstops < Jennifer::Migration::Base
  def up
    create_table :travelstops do |t|
      t.string :name, {:null => false}
      t.string :type, {:null => false}
      t.string :dimension, {:null => false}

      t.timestamps
    end
  end

  def down
    drop_table :travelstops if table_exists? :travelstops
  end
end
