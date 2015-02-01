class User < ActiveRecord::Base
  include RatingAverage
end
