require 'rails_helper'

describe Mutations::CreateReservation do
  describe 'CreateReservation' do
    let(:query) do
      %|
        mutation($input: CreateReservationInput!) {
          createReservation(input: $input) {
            reservation {
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
    let (:end_date) { (Date.today + 2.days).to_s }
    let (:variables) do
      {
        "input" => {
          'placeId' => 1,
          'startDate' => start_date,
          'endDate' => end_date  
        }
      }
    end
    let (:user) { User.create!(email: 'test@test.com', password: 'password') }
    let (:context) { {current_user: user} }
    let (:place) { Place.create!(address_1: '2031 26th st', city: 'San Francisco', state: 'CA', country: 'USA', price: 100)}
    
    
    it 'creates a reservation' do
      allow(Place).to receive(:find).and_return(place)
      result = Schema.execute(query, variables: variables, context: context, operation_name: nil)
      reservation = result.to_h['data']['createReservation']['reservation']
      expect(Date.parse(reservation['startDate']).to_s).to eq(start_date)
      expect(Date.parse(reservation['endDate']).to_s).to eq(end_date)
    end
  end
end
