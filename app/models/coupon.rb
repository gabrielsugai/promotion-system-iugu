class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 10}

  delegate :discount_rate, to: :promotion

  def self.search(code)
    find_by(code: code)
  end

  def as_json(options = {})
    super({methods: :discount_rate}.merge(options))
  end
end