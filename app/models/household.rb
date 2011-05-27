class Household < ActiveRecord::Base
  attr_accessible :name, :credits

  has_many :children
  has_many :users
  has_many :requests

  before_create :assign_default_credits

  def to_s
    self.name
  end

  protected

    def assign_default_credits
      self.credits = 0 if self.credits.nil?
    end
end

