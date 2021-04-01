require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção encontrada'
  end

  test 'can not search promotions without login' do
    visit search_promotions_path(q: 'test')

    assert_current_path new_user_session_path
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
     
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'edit a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar'

    fill_in 'Nome', with: 'Ano novo'
    fill_in 'Descrição', with: 'Comece o ano com uma otima promoção'
    fill_in 'Código', with: 'ANO10'
    click_on 'Editar'

    assert_current_path promotion_path(promotion)

    assert_text 'Ano novo'
    assert_text 'Comece o ano com uma otima promoção'
    assert_text 'ANO10'
  end

  test 'delete a promotion' do
    user = login_user
    Promotion.create!(name: 'Natal', 
                      description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, 
                      coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Excluir'
    page.driver.browser.switch_to.alert.accept

    assert_current_path promotions_path

    assert_no_text 'Natal'
    assert_no_text 'Promoção de Natal'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path

    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    assert_text 'já está em uso', count: 2
  end

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

  test 'search promotions by term and finds results' do
    user = login_user
    xmas = create(:promotion, name: 'Natal', user: user)
    xmassy = create(:promotion, name: 'Natalina', user: user)
    cyber = create(:promotion, name: 'Cyber Monday', user: user)

    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text xmas.name
    assert_text xmassy.name
    refute_text cyber.name
  end

  test 'search with a nil term and redirect to all promotions' do
    user = login_user
    xmas = create(:promotion, name: 'Natal', user: user)
    xmassy = create(:promotion, name: 'Natalina', user: user)
    cyber = create(:promotion, name: 'Cyber Monday', user: user)

    visit promotions_path
    click_on 'Buscar'

    assert_text xmas.name
    assert_text xmassy.name
    assert_text cyber.name
  end

  test 'search doesnt find the requested term' do
    user = login_user
    xmas = create(:promotion, name: 'Natal', user: user)
    xmassy = create(:promotion, name: 'Natalina', user: user)
    cyber = create(:promotion, name: 'Cyber Monday', user: user)

    visit promotions_path
    fill_in 'Busca', with: 'carnaval'
    click_on 'Buscar'
    
    refute_text xmas.name
    refute_text xmassy.name
    refute_text cyber.name
    assert_text 'Nenhuma promoção encontrada'
  end

  test 'do not view promotion link without login' do
    visit root_path
    assert_no_link 'Promoções'
  end

  test 'do not view promotions without login' do
    visit promotions_path
    assert_current_path new_user_session_path
  end

  test 'do not view a promotion details without login' do
    user = create(:user)
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', 
                                  discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit promotion_path(promotion)
    assert_current_path new_user_session_path
  end

  test 'do not create a new promotion without login' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end
  
  test 'do not edit a promotion without login' do
    user = create(:user)
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', 
                                  discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit edit_promotion_path(promotion)
    assert_current_path new_user_session_path
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

  # TODO: test de login para aprovar
end