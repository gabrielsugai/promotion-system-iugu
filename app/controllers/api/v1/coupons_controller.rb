class Api::V1::CouponsController < Api::V1::ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  def show
    @coupon = Coupon.find_by!(code: params[:code])
    render json: @coupon.as_json
  end

  private
    def not_found_error
      head 404
    end
end