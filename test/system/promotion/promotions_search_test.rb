require 'application_system_test_case'

class PromotionsSearchTest < ApplicationSystemTestCase
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

  test 'can not search promotions without login' do
    visit search_promotions_path(q: 'test')

    assert_current_path new_user_session_path
  end
end