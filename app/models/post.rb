class Post < ActiveRecord::Base
  attr_accessible :title, :artist, :description, :date, :price
end
