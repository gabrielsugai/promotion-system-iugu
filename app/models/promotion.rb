class Promotion < ApplicationRecord
  has_many :coupons
  belongs_to :user
  has_one :promotion_approval
  has_one :approver, through: :promotion_approval, source: :user

  validates :name, :discount_rate, :coupon_quantity, :expiration_date, 
            :code, presence: true
  
  validates :code, :name, uniqueness: true

  def generate_coupons!
    return unless coupons.empty?
    (1..coupon_quantity).each do |number|
      coupons.create!(code: "#{code}-#{'%04d' % number}")
    end
  end

  def approved?
    promotion_approval.present?
  end

  def self.search(query)
    where('name LIKE ?', "%#{query}%")
  end

  def can_approve?(current_user)
    user != current_user
  end
end
