class Api::V1::TransactionsController < Api::ApiController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def all
      @transactions = Transaction.all
      render json: all_revenues(@transactions)
  end

  def one_country
      @transactions = Transaction.all
      render json: calculate_one_country(@transactions, params[:country])
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
        one_transac_one_country = transactions.select(:country).distinct
        countries = one_transac_one_country.map  { |country| country.country }

        datetime = transactions.select([:date, :unit_price, :quantity]).order('date').map { |t| {"date": t.date.to_s[0..6], "amount": t.unit_price * t.quantity}}
        unique_datetime = datetime.uniq { |d| d.first }.last(30) 


        sum = transactions.map { |transaction| transaction.quantity * transaction.unit_price }.sum
        number_orders = transactions.select(:order_id).distinct.count
        number_customers = transactions.select(:customer_id).distinct.count

        {
          status: 'success',
          countries: countries,
          datetime: unique_datetime,
          revenues: sum,
          avg_revenues: sum / number_orders,
          customers: number_customers,
        }
    end

    def calculate_one_country(transactions, country)
        one_transac_one_country = transactions.select(:country).distinct
        countries = one_transac_one_country.map  { |country| country.country }

        datetime = transactions.where(country: country).select([:date, :unit_price, :quantity]).order('date').map { |t| {"date": t.date.to_s[0..6], "amount": t.unit_price * t.quantity}}
        unique_datetime = datetime.uniq { |d| d.first }.last(30)    

        sum = transactions.where(country: country).map { |transaction| transaction.quantity * transaction.unit_price }.sum
        number_orders = transactions.where(country: country).select(:order_id).distinct.count
        number_customers = transactions.where(country: country).select(:customer_id).distinct.count

        {
          status: 'success',
          countries: countries,
          datetime: unique_datetime,
          revenues: sum,
          avg_revenues: sum / number_orders,
          customers: number_customers,
        }
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:date, :order_id, :customer_id, :country, :product_code, :product_description, :quantity, :unit_price)
    end
end
