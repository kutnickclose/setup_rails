# mutation($input: RelocateReservationInput!) {
#   relocateReservation(input: $input) {
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

#this currently just relocates the place to the last place

#TODO: add original_end_date to Reservation
#TODO: add parent_reservation_id to Reservation

class Mutations::RelocateReservation < Mutations::BaseMutation
  argument :reservation_id, ID, required: true
  argument :new_place_id, ID, required: true
  argument :new_place_start_date, String, required: true
  
  field :reservation, Types::ReservationType, null: true
  field :new_reservation, Types::ReservationType, null: true
  field :errors, [String], null: true

  def resolve(reservation_id:, new_place_id:, new_place_start_date:)
    reservation = Reservation.find(reservation_id)
    raise GraphQL::ExecutionError, 'unable to find reservation' unless reservation
    
    #logic for relocation
    # new_place = Place.last
    
    new_place_start_date_parsed = Date.parse(new_place_start_date)
    
    #track the changes to reservation
    reservation.paper_trail_event = 'Relocate'
    
    #end the current reservation at the start date of the new reservation
    reservation.update(original_end_date: reservation.end_date)
    reservation.update(end_date: new_place_start_date_parsed)
    
    #create a new reservation with the start date passed in + the end date of the original reservation 
    user = reservation.user
    new_reservation = user.reservations.build(
      start_date: new_place_start_date_parsed, 
      end_date: reservation.original_end_date, 
      place_id: new_place_id,
      parent_reservation_id: reservation.id
    )    
    
    new_reservation.save
    
    {
      reservation: reservation,
      new_reservation: new_reservation
    }
    
    
    
    
    # if reservation.update(place: new_place)
    #   {
    #     reservation: reservation
    #   }
    # else
    #   {
    #     reservation: nil,
    #     errors: new_reservation.errors.full_messages
    #   }
    # end
  end
end