require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    user = create(:user)
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(code: 'NATAL10')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    user = create(:user)
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test 'generate_coupons! succesfully' do
    user = create(:user)
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.generate_coupons!
    assert promotion.coupons.size == promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    user = create(:user)
    promotion = Promotion.create!(name: 'Natal', 
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: 'COUPON-TEST', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search by exact' do
    christmas = create(:promotion, name: 'Natal')
    cyber = create(:promotion, name: 'Cyber Monday')

    result = Promotion.search('Natal')
    assert_includes result, christmas
    refute_includes result, cyber
  end

  test '.search by partial' do
    christmas = create(:promotion, name: 'Natal')
    xmas = create(:promotion, name: 'Natalina')
    cyber = create(:promotion, name: 'Cyber Monday')

    result = Promotion.search('natal')
    assert_includes result, christmas
    assert_includes result, xmas
    refute_includes result, cyber
  end

  test '.search finds nothing' do
    christmas = create(:promotion, name: 'Natal')
    cyber = create(:promotion, name: 'Cyber Monday')

    result = Promotion.search('carnaval')

    assert_empty result
  end

end
