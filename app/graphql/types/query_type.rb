class Types::QueryType < Types::BaseObject
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :place, Types::PlaceType, null: true do
    description "Find a place by ID"
    argument :id, ID, required: true
  end
  
  field :places, [Types::PlaceType], null: true do
    description "Find a places"
  end

  # Then provide an implementation:
  def place(id:)
    Place.find(id)
  end
  
  def places
    Place.all
  end
end
