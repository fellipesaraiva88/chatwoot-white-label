class EvolutionApiConfigPolicy < ApplicationPolicy
  def index?
    @account_user.administrator?
  end

  def create?
    @account_user.administrator?
  end

  def show?
    @account_user.administrator?
  end

  def update?
    @account_user.administrator?
  end

  def destroy?
    @account_user.administrator?
  end

  def test_connection?
    @account_user.administrator?
  end

  def sync_now?
    @account_user.administrator?
  end
end
