require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do
    login_user
    post '/promotions', params: { promotion: { name: 'Natal', 
                                  description: 'Promoção de natal', 
                                  code: 'NATAL10', 
                                  discount_rate: 15, 
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033'} }
    assert_redirected_to promotion_path(Promotion.last)
    follow_redirect!
    assert_select 'h2', 'Natal'
  end

  test 'cannot create a promotion without a login' do
    post '/promotions', params: { promotion: { name: 'Natal', 
                                  description: 'Promoção de natal', 
                                  code: 'NATAL10', 
                                  discount_rate: 15, 
                                  coupon_quantity: 5,
                                  expiration_date: '22/12/2033'} }
    assert_redirected_to new_user_session_path
  end

  test 'cannot generate coupons without a login' do
    user = create(:user)
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', 
                                  discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    post generate_coupons_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'cannot update a promotion without a login' do
    promotion = create(:promotion)
    
    patch promotion_path(promotion), params: { promotion: { name: 'NATAL' } }
    assert_redirected_to new_user_session_path
  end

  test 'cannot delete a promotion without a login' do
    promotion = create(:promotion)
    
    delete promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'user cannot approves a promotion without a login' do
    promotion = create(:promotion)

    post approve_promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'user cannot approves his own promotion' do
    user = login_user
    promotion = create(:promotion, user: user)

    post approve_promotion_path(promotion)

    assert_redirected_to promotion_path(promotion)
    follow_redirect!
    assert_equal 'Ação negada!', flash[:alert]
    refute promotion.reload.approved?
  end

end