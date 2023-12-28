class Admin::CategoriesController < ApplicationController

  def index
    @categories = Category.includes(image_attachment: [:blob])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if(@category.ancestry == "")
      @category.ancestry = nil
    end
    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def destroy_category
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
  end

  def edit
    @category = Category.find(params[:id])
    @is_edit = true;
    render 'admin/categories/new'
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render 'edit_category'
    end
  end



  private

  def category_params
    params.require(:category).permit(:title, :ancestry, :image)
  end


end
