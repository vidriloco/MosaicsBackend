class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :meta_question_id
      t.integer :survey_id
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
  
  def self.down
    drop_table :questions
  end
end
