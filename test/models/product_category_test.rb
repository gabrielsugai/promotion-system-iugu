require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    category = ProductCategory.new

    refute category.valid?
    assert_includes category.errors[:name], 'não pode ficar em branco'
    assert_includes category.errors[:code], 'não pode ficar em branco'
  end

  test 'code and name must be uniq' do
    ProductCategory.create!(name: 'Produto Teste', code: 'TESTE')
    category = ProductCategory.new(name: 'Produto Teste', code: 'TESTE')

    refute category.valid?
    assert_includes category.errors[:name], 'deve ser único'
    assert_includes category.errors[:code], 'deve ser único'
  end
end

