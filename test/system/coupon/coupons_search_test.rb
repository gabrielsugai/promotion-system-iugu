require 'application_system_test_case'

class CouponsSearchTest < ApplicationSystemTestCase
  test 'search a coupon' do
    promotion = create(:promotion, name: 'Natal', discount_rate: 10, 
                        expiration_date: '03/04/2033')
    create(:promotion_approval, promotion: promotion)
    coupon = create(:coupon, code: 'NATAL10-0001', promotion: promotion)
    another_coupon = create(:coupon, code: 'NATAL10-0002', promotion: promotion)
    login_user
    
    visit promotion_path(promotion)
    fill_in 'Buscar cupom', with: 'NATAL10-0001'
    click_on 'Buscar'

    assert_text 'NATAL10-0001'
    assert_text 'Ativo'
    assert_text 'Natal'
    assert_text coupon.promotion.description
    assert_text 'NATAL10'
    assert_text '10,00%'
    assert_text '03/04/2033'

    refute_text another_coupon.code

    assert_current_path coupon_path(coupon)
  end

  test 'coupon not found' do
    promotion = create(:promotion, name: 'Natal')
    login_user

    visit promotion_path(promotion)
    fill_in 'Buscar cupom', with: 'PASCOA10-0001'
    click_on 'Buscar'

    assert_text 'Cupom não encontrado'

    assert_current_path promotions_path
  end
end
