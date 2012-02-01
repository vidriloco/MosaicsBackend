class CreateMetaQuestions < ActiveRecord::Migration
  def self.up
    create_table :meta_questions do |t|
      # id rango: 10000 a 20000
      t.integer :meta_survey_id
      t.string :title
      t.string :instruction
      t.string :order_identifier
      t.string :type_of
      t.timestamps
    end
    
    execute 'CREATE SEQUENCE idGenMetaQuestions START 10000;'
    execute "ALTER TABLE \"meta_questions\" ALTER COLUMN \"id\" set DEFAULT NEXTVAL('idGenMetaQuestions');"
  end

  def self.down
    drop_table :meta_questions
    execute "DROP SEQUENCE idGenMetaQuestions;"
  end

end
