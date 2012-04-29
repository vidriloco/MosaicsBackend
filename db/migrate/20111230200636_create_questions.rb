class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.datetime :start_time
      t.datetime :end_time
    end
  end
  
  def self.down
    drop_table :questions
  end
end
