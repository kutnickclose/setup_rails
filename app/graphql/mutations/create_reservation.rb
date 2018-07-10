# mutation($input: CreateReservationInput!) {
#   createReservation(input: $input) {
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

class Mutations::CreateReservation < Mutations::BaseMutation
  argument :place_id, ID, required: true
  argument :start_date, String, required: true
  argument :end_date, String, required: true

  field :reservation, Types::ReservationType, null: true
  field :errors, [String], null: true

  def resolve(place_id:, start_date:, end_date:)
    current_user = context[:current_user]
    raise GraphQL::ExecutionError, 'must login to make a reservation' unless current_user
    
    place = Place.find(place_id)
    start_date_parsed = Date.parse(start_date)
    end_date_parsed = Date.parse(end_date)
    days = end_date_parsed - start_date_parsed
    
    reservation = current_user.reservations.build(
      start_date: start_date_parsed, 
      end_date: end_date_parsed, 
      place: place,
      price: place.price,
      total: place.price * days
    )
    
    if reservation.save
      {
        reservation: reservation
      }
    else
      {
        reservation: nil,
        errors: reservation.errors.full_messages
      }
    end
  end
end