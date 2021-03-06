class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true
  #validates :brewery_id, presence: true
  belongs_to :style

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    return sorted_by_rating_in_desc_order.take(n);
  end



  def to_s
    "#{name} #{brewery.name}"
  end
end
