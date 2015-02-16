class AddBeerStyle < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :style
      t.text :description

      t.timestamps null: false
    end

    tyylit = Beer.uniq.pluck(:style)
    tyylit.each do |t|
      Style.create style:t
    end
  end
end