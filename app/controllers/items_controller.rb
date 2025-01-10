class ItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show new create edit update destroy]

  def index
    @items = Item.all

    if @items.blank?
      flash.now[:notice] = "Aucun item ne correspond aux filtres sélectionnés."
    end
    # Autres filtres ici...

    # Pour afficher la liste d item filtrée dans la vue
    render 'index'
  end

  def show
    @item = Item.find(params[:id])
  end


  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    @item.save
    redirect_to dashboard_path
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to dashboard_path, status: :see_other
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

end
