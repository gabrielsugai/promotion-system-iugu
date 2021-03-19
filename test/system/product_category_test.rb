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
  end
end