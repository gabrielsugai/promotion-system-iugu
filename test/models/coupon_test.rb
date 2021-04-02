require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test '.search by exact' do
    promotion = create(:promotion, name: 'Pascoa', discount_rate: 10)
    cyber = create(:promotion, name: 'Cyber', discount_rate: 10)
    coupon = create(:coupon, promotion: promotion)
    another_coupon = create(:coupon, promotion: cyber)

    result = Coupon.search(coupon.code)
    assert_equal result, coupon
    refute_equal result, another_coupon
  end

  test '.search finds nothing' do
    promotion = create(:promotion, name: 'Pascoa', discount_rate: 10)
    cyber = create(:promotion, name: 'Cyber', discount_rate: 10)
    coupon = create(:coupon, promotion: promotion)
    another_coupon = create(:coupon, promotion: cyber)

    result = Coupon.search('CARNA10-0001')

    refute result
  end
end
