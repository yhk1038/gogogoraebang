class CreateFeelings < ActiveRecord::Migration
  def change
    create_table :feelings do |t|
      t.string :feeling_icon
      t.timestamps null: false
    end
  end
end
