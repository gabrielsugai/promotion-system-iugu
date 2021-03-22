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
    if @product_category.save
      redirect_to @product_category
    else
      render :new
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  def update
    @product_category = ProductCategory.find(params[:id])
    @product_category.update(category_params)
    redirect_to @product_category
  end

  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy
    redirect_to product_categories_path
  end

  private
    
    def category_params
      params.require(:product_category).permit(:name, :code)
    end
end