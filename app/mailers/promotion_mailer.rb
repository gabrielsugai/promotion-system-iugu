class PromotionMailer < ApplicationMailer
  def approval_email
    @promotion = params[:promotion]
    @user = params[:user]
    mail(to: @promotion.user.email, subject: "Sua promoção \"#{@promotion.name}\" foi aprovada")
  end
end