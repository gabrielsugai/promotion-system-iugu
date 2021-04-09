class PromotionMailerPreview < ActionMailer::Preview
  def approval_email
    #localhost:3000/rails/mailers para ver o email
    PromotionMailer
      .with(user: User.first, promotion: Promotion.first)
      .approval_email
  end
end