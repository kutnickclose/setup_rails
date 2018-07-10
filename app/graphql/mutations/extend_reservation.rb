# mutation($input: ExtendReservationInput!) {
#   extendReservation(input: $input) {
#     # This will be present in case of success or failure:
#     reservation {
#       startDate
#       endDate
#       placeId
#     }
#     # In case of failure, there will be errors in this list:
#     errors
#   }
# }

#all this currently does is change the end date to w/e you pass in

class Mutations::ExtendReservation < Mutations::BaseMutation
  argument :reservation_id, ID, required: true
  argument :end_date, String, required: true

  field :reservation, Types::ReservationType, null: true
  field :errors, [String], null: true

  def resolve(reservation_id:, end_date:)
    current_user = context[:current_user]
    raise GraphQL::ExecutionError, 'must login to make a reservation' unless current_user
    
    reservation = Reservation.find(reservation_id)
    raise GraphQL::ExecutionError, 'unable to find reservation' unless reservation
    
    reservation.paper_trail_event = 'Extend Reservation'
    if reservation.update(end_date: end_date)
      {
        reservation: reservation
      }
    else
      {
        reservation: nil,
        errors: new_reservation.errors.full_messages
      }
    end
  end
end