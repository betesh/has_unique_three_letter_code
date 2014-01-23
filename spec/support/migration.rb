class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :tla
      t.string :name
      t.integer :tla_group, :default => 0
      t.boolean :needs_tla, :default => true
      t.timestamps
    end
  end
  def self.down
    drop_table :clients
  end
end
