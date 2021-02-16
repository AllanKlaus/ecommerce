class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(orders_params)

    if @order.save
      redirect_to @order, notice: 'Pedido was successfully created.'
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def orders_params
    params.require(:order).permit(products: [])
  end
end
