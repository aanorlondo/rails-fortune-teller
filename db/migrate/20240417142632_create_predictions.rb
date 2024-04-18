class CreatePredictions < ActiveRecord::Migration[7.1]
  def change
    create_table :predictions do |t|
      t.string :text
      t.timestamps
    end
  end
end
