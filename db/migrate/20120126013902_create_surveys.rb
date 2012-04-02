class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :meta_survey_id
      t.integer :pollster_id
      t.integer :device_id
      
      t.timestamps
    end
  end
end
