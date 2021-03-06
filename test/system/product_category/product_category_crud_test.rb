require 'application_system_test_case'

class ProductCategoriesCrudTest < ApplicationSystemTestCase
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

  test 'create category' do
    visit root_path
    click_on 'Categorias de produto'
    click_on 'Registrar uma categoria'
    fill_in 'Nome', with: 'Produto AntiFraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Criar categoria'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
    assert_link 'Voltar'
    assert_current_path product_category_path(ProductCategory.last)
  end

  test 'edit a category' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Editar categoria'
    fill_in 'Código', with: 'TESTE'
    click_on 'Editar categoria'

    assert_text 'Produto AntiFraude'
    assert_text 'TESTE'
    assert_current_path product_category_path(ProductCategory.last)
  end

  test 'delete a category' do
    category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_category_path(category)
    click_on 'Excluir'
    page.driver.browser.switch_to.alert.accept

    assert_current_path product_categories_path

    assert_no_text 'Produto AntiFraude'
    assert_no_text 'ANTIFRA'
  end

  test 'create and attributes cannot be blank' do
    visit root_path

    click_on 'Categorias de produto'
    click_on 'Registrar uma categoria'
    click_on 'Criar categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'create and code/name must be unique' do
    ProductCategory.create!(name: 'Produto Teste', code: 'TESTE')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Registrar uma categoria'
    fill_in 'Nome', with: 'Produto Teste'
    fill_in 'Código', with: 'TESTE'
    click_on 'Criar categoria'

    assert_text 'deve ser único', count: 2
  end
end