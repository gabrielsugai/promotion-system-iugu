require 'test_helper'

class CouponFlowTest < ActionDispatch::IntegrationTest
  test 'can not disable a coupon without a login' do
    coupon = create(:coupon)

    post disable_coupon_path(coupon)

    assert_redirected_to new_user_session_path
  end

  test 'can not active a coupon without a login' do
    coupon = create(:coupon, status: 10)

    post active_coupon_path(coupon)

    assert_redirected_to new_user_session_path
  end

  test 'can not search a coupon without a login' do
    promotion = create(:promotion, name: 'Natal', discount_rate: 10)
    coupon = create(:coupon, code: 'NATAL10-0001', promotion: promotion)
    
    get search_coupons_path, params: { q: 'NATAL10-0001'}

    assert_redirected_to new_user_session_path
  end
end