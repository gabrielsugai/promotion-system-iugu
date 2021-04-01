require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    coupon = create(:coupon)
    
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
  end
end