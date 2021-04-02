class CouponsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coupon, only: [:show, :disable, :active]

  def show
  end

  def disable
    @coupon.disabled!
    # redirect_to @coupon.promotion, notice: "Cupom #{@coupon.code} desabilitado com sucesso"
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end

  def active
    @coupon.active!
    redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
  end

  def search
    @coupon = Coupon.search(params[:q])
    if @coupon
      redirect_to @coupon
    else
      redirect_to promotions_path, notice: t('.not_found')
    end
  end

  private
    def set_coupon
      @coupon = Coupon.find(params[:id])
    end
end