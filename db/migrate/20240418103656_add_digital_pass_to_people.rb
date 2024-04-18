class AddDigitalPassToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :digital_pass, :boolean, null: false, default: true
  end
end
