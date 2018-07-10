class Types::MutationType < Types::BaseObject
  field :createReservation, mutation: Mutations::CreateReservation
  field :extendReservation, mutation: Mutations::ExtendReservation
  field :relocateReservation, mutation: Mutations::RelocateReservation
end
