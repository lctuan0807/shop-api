class Reservation < ApplicationRecord
  belongs_to :inventory
  belongs_to :cart
end
