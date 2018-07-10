require 'rails_helper'

describe Mutations::RelocateReservation do
  describe 'RelocateReservation' do
    let(:query) do
      %|
        mutation($input: RelocateReservationInput!) {
          relocateReservation(input: $input) {
            reservation {
              startDate
              endDate
              placeId
            }
            newReservation {
              startDate
              endDate
              placeId
            }
            errors
          }
        }
       |
    end
    let (:start_date) { Date.today.to_s }
    let (:end_date) { (Date.today + 10.days).to_s }
    let (:place) { Place.create!(address_1: '2031 26th st', city: 'San Francisco', state: 'CA', country: 'USA', price: 100)}
    let (:new_place) { Place.create!(address_1: '2021 26th st', city: 'San Francisco', state: 'CA', country: 'USA', price: 100) }
    let (:user) { User.create!(email: 'test@test.com', password: 'password') }
    let (:reservation) { Reservation.create!(place: place, user: user, start_date: start_date, end_date: end_date ) }
    let (:new_place_start_date) { (Date.today + 5.days).to_s }
    let (:variables) do
      {
        "input" => {
          'reservationId' => reservation.id,
          'newPlaceId' => new_place.id,
          'newPlaceStartDate' => new_place_start_date
        }
      }
    end
    let (:context) { {current_user: user} }
    
    
    it 'creates a reservation' do
      # allow(Place).to receive(:find).and_return(place)
      result = SonderPracticeSchema.execute(query, variables: variables, context: context, operation_name: nil)
      
      reservation = result.to_h['data']['relocateReservation']['reservation']
      new_reservation = result.to_h['data']['relocateReservation']['newReservation']
      
      expect(Date.parse(reservation['endDate']).to_s).to eq(new_place_start_date)
      expect(Date.parse(new_reservation['startDate']).to_s).to eq(new_place_start_date)
      expect(Date.parse(new_reservation['endDate']).to_s).to eq(end_date)
    end
  end
end
