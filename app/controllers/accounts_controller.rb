class AccountsController < AuthenticatedController
  def index
    @transaction_accounts = Account.transactional
    @savings_accounts = Account.savers
  end
end
