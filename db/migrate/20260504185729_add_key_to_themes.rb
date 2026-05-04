class AddKeyToThemes < ActiveRecord::Migration[7.1]
  def change
    add_column :themes, :key, :string
    add_index  :themes, :key, unique: true
  end
end