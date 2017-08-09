class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.boolean :active
      t.text :content
      t.references :doctor, index: true
      t.boolean :approved

      t.timestamps
    end
  end
end
