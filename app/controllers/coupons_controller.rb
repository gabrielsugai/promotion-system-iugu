class CouponsController < ApplicationController
  before_action :authenticate_user!

  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    # redirect_to @coupon.promotion, notice: "Cupom #{@coupon.code} desabilitado com sucesso"
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end

  def active
    @coupon = Coupon.find(params[:id])
    @coupon.active!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end
end