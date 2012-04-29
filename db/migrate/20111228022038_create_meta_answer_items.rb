class CreateMetaAnswerItems < ActiveRecord::Migration
  def self.up
    create_table :meta_answer_items do |t|
      t.integer :meta_question_id
      t.string :human_value
      t.string :order_identifier
      t.string :identifier
      t.timestamps
    end
    
    execute 'CREATE SEQUENCE idGenMetaAnswerItems START 20000;'
    execute "ALTER TABLE \"meta_answer_items\" ALTER COLUMN \"id\" set DEFAULT NEXTVAL('idGenMetaAnswerItems');"
    
    add_index(:meta_answer_items, :identifier, :unique => true, :name => "meta_answer_items_identifier_idx")
  end
  
  def self.down
    drop_table :meta_answer_items
    execute "DROP SEQUENCE idGenMetaAnswerItems;"
  end
end
