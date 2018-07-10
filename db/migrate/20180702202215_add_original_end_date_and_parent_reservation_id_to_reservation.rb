class AddOriginalEndDateAndParentReservationIdToReservation < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :original_end_date, :datetime
    add_column :reservations, :parent_reservation_id, :integer
  end
end
