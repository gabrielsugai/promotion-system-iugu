class Promotion < ApplicationRecord
  has_many :coupons
  validates :name, :discount_rate, :coupon_quantity, :expiration_date, 
            :code, presence: true
  
  validates :code, :name, uniqueness: true

  def generate_coupons!
    return unless coupons.empty?
    (1..coupon_quantity).each do |number|
      coupons.create!(code: "#{code}-#{'%04d' % number}")
    end
  end
end
