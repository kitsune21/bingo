class SquareCategory < ApplicationRecord
  belongs_to :user
  has_many :squares
end
