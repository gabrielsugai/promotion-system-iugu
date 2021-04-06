require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    promotion = create(:promotion, discount_rate: 15)
    coupon = create(:coupon, promotion: promotion)
    
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
    # assert_equal coupon.code, body[:code]

  end

  test 'show coupon not found' do
    get '/api/v1/coupons/0'

    assert_response :not_found
  end
end