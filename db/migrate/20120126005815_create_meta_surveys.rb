class CreateMetaSurveys < ActiveRecord::Migration
  def change
    create_table :meta_surveys do |t|
      t.string  :name
      t.string  :identifier
      t.integer :size
      t.integer :organization_id
      
      t.timestamps
    end
  end
end
