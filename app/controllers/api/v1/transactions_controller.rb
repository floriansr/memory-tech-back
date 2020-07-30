class Api::V1::TransactionsController < Api::ApiController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def all
      @transactions = Transaction.all
      render json: all_revenues(@transactions)
  end

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def all_revenues(transactions)
        {
          status: 'success',
          revenues: (transactions.map { |transaction| transaction.quantity * transaction.unit_price }).sum,
        }
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:date, :order_id, :customer_id, :country, :product_code, :product_description, :quantity, :unit_price)
    end
end
