class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 10}

  def self.search(code)
    find_by(code: code)
  end
end