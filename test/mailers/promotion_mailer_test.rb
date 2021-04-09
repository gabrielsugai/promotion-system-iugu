require 'test_helper'

class PromotionMailerTest < ActionMailer::TestCase
  test 'approval_email' do
    user = create(:user, email: 'approver@iugu.com.br')
    promotion = create(:promotion, name: 'Carnaval')
    email = PromotionMailer.with(user: user, promotion: promotion).approval_email

    assert_equal [promotion.user.email], email.to
    assert_includes email.body, user.email
    assert_equal 'Sua promoção "Carnaval" foi aprovada', email.subject
  end
end