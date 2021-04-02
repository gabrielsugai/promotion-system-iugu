require 'application_system_test_case'

class PromotionsCouponsTest < ApplicationSystemTestCase
  test 'generate coupons for a promotion' do
    user = create(:user)
    approver = login_user
    promotion = create(:promotion, name: 'Natal', user: user, discount_rate: 10)
    create(:promotion_approval, user: approver, promotion: promotion)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001 (Ativo)'
    assert_text 'NATAL10-0002 (Ativo)'
    assert_text 'NATAL10-0100 (Ativo)'
    assert_no_text 'NATAL10-0101'
    assert_link 'Desabilitar', count: 100
  end

  test 'can not generate coupons without an approve' do
    promotion = create(:promotion)

    login_user
    visit promotion_path(promotion)

    refute_link 'Gerar cupons'
  end

  test 'user approves promotion' do
    user = create(:user)
    promotion = create(:promotion, user: user)
    
    approver = login_user
    visit promotion_path(promotion)
    accept_confirm { click_on 'Aprovar' }

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
  end

  test 'user cannot see the approves button' do
    user = login_user
    promotion = create(:promotion, user: user)

    visit promotion_path(promotion)

    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end
end