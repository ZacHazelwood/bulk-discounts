class BulkDiscountsController < ApplicationController
  before_action :find_merchant

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def new; end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
      flash[:success] = "You have successfully created a Discount"
    else
      redirect_to new_merchant_bulk_discount_path(@merchant)
      flash[:notice] = "Please fill out all available fields"
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    if discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, discount)
      flash[:success] = "You have successfully updated this discount"
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, discount)
      flash[:notice] = "Please fill out all available fields"
    end
  end

  private

    def bulk_discount_params
      params.permit(:name, :percent_discount, :threshold)
    end
end
