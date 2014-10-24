class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string      :name
      t.string      :avatar_uid
      t.string      :occupation
      t.integer     :salary
      t.float       :stock_options
      t.date        :hired_on
      t.date        :fired_on
      t.text        :previous_occupations
      t.timestamps null: false
    end
  end
end
