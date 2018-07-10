class Place < ApplicationRecord
  geocoded_by :address
  after_validation :geocode
  
  has_many :reservations
  
  def address
    [address_1, city, state, country].compact.join(', ')
  end
end
