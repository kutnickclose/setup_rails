class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :place
  has_many :child_reservations, foreign_key: 'parent_reservation_id', class_name: 'Reservation'
  
  has_paper_trail
end
