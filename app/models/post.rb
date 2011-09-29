class Post < ActiveRecord::Base
  attr_accessible :title, :artist, :description, :date, :price
  
  has_attached_file :photo, 
                    :styles => {
                      :thumb => "200x200>",
                      :medium => "600x600>",
                      :tiny => "25x25>"
                    },
                    :url => "/assets/:class/:attachment/:id/:style.:extension",
                    :path => "#{RAILS_ROOT}/public/assets/:class/:attachment/:id/:style.:extension",
                    :default_url => "/images/default_household_:style.jpg"
end
