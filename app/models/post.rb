class Post < ActiveRecord::Base
  attr_accessible :title, :artist, :description, :date, :price
  
  has_attached_file :photo, 
                    :url => "/assets/:class/:attachment/:id/:style.:extension",
                    :path => "#{RAILS_ROOT}/public/assets/:class/:attachment/:id/:style.:extension"
end
