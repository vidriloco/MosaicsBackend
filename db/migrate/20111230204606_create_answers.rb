class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer   :meta_answer_option_id
      t.integer   :meta_answer_item_id
      t.integer   :meta_question_id
      t.integer   :meta_survey_id
      
      t.string    :open_value
      
      # extending data models
      t.integer   :question_id
      t.integer   :survey_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :answers
  end
end
