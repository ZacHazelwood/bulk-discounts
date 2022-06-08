class ApplicationController < ActionController::Base
  before_action :repository_info, only: [:index, :show, :new, :edit]
  before_action :contributor_info, only: [:index, :show, :new, :edit]

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def repository_info
    @repository = RepositoryFacade.create_repo_or_error
  end

  def contributor_info
    @contributors = RepositoryFacade.create_contributors
  end
end
