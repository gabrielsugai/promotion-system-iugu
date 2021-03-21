class ProductCategoriesController < ApplicationController

  def index
    @product_categories = ProductCategory.all
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(category_params)
    @product_category.save
    redirect_to @product_category
  end

  private
    
    def category_params
      params.require(:product_category).permit(:name, :code)
    end
end