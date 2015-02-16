class ChangeBeer < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer

    Beer.all.each do |b|
      b.style = Style.find_by style:b.old_style
      b.save
    end
    remove_column :beers, :old_style, :string
  end
end
