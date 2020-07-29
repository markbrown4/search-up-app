class TransactionsController < AuthenticatedController
  def index
    @transactions = Transaction.order('created_at DESC').search(params[:search])

    if params[:account_id].present?
      @transactions = @transactions.where(external_account_id: params[:account_id])
      @account = Account.find_by(external_id: params[:account_id])
    end

    calculate_running_balance
    calculate_insights
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  def calculate_running_balance
    balance = 0
    @running_balance = []
    @transactions.reverse.each do |t|
      balance += t.total_amount_in_cents
      @running_balance << [balance, t.created_at]
    end
    @running_balance.reverse!
  end

  def calculate_insights
    @count = @transactions.count
    @sum = @count > 0 ? @transactions.map(&:total_amount_in_cents).sum(0.0) : 0
    @average = @count > 0 ? @sum / @count : 0
  end
end
