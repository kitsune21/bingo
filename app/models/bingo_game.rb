class BingoGame < ApplicationRecord
  belongs_to :user
  has_many :squares, dependent: :destroy
end
