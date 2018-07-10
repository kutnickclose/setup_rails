class Types::ReservationType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :start_date, String, null: false
  field :end_date, String, null: false
  field :place_id, ID, null: false
end