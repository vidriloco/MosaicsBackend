class CreateMetaAnswerOptions < ActiveRecord::Migration
  def self.up
    create_table :meta_answer_options do |t|
      t.integer :meta_question_id
      t.string :human_value
      t.string :identifier
      t.timestamps
    end
  end
  
  def self.down
    drop_table :meta_answer_options
  end
end
