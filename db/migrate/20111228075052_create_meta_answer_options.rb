class CreateMetaAnswerOptions < ActiveRecord::Migration
  def self.up
    create_table :meta_answer_options do |t|
      t.integer :meta_question_id
      t.string :human_value
      t.string :order_identifier
      t.string :identifier
      t.timestamps
    end
    
    add_index(:meta_answer_options, :identifier, :unique => true, :name => "meta_answer_options_identifier_idx")
  end
  
  def self.down
    drop_table :meta_answer_options
  end
end
