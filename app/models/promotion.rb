class Promotion < ApplicationRecord
  validates :name, :discount_rate, :coupon_quantity, :expiration_date, 
            :code, presence: { message: 'não pode ficar em branco'}
  
  validates :code, :name, uniqueness: { message: 'deve ser único'}
end
