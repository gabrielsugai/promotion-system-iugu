class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: [:show, :edit, :update, 
                                       :destroy, :generate_coupons, :approve, :check_user]
  before_action :check_user, only: [:approve]
  def index
    @promotions = Promotion.all
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = current_user.promotions.new(promotion_params)
    if  @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
  end

  def update
    @promotion.update(promotion_params)
    redirect_to @promotion
  end

  def destroy
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    @promotion.generate_coupons!
    redirect_to @promotion, notice: 'Cupons gerados com sucesso'
  end

  def search
    @promotions = Promotion.search(params[:q])
    render :index
  end

  def approve
    current_user.promotion_approvals.create!(promotion: @promotion)
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
  end

  private

    def check_user
      redirect_to @promotion, 
      alert: 'Ação negada!' unless @promotion.can_approve?(current_user)
    end

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params
        .require(:promotion)
        .permit(:name, :expiration_date, :description,
                :discount_rate, :code, :coupon_quantity)
    end
end