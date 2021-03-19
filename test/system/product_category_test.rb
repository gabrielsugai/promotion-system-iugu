require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'view product categories' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Teste', code: 'TEST')

    visit root_path
    click_on 'Categorias de produto'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
    assert_text 'Produto Teste'
    assert_text 'TEST'
    assert_link 'Voltar'
  end

  test 'view product categories details' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Teste', code: 'TEST')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Produto AntiFraude'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
    assert_no_text 'Produto Teste'
    assert_no_text 'TEST'
    assert_link 'Voltar'
  end

  test 'no category are available' do
    visit root_path
    click_on 'Categorias de produto'

    assert_text 'Nenhuma categoria de produto cadastrada'
  end
end