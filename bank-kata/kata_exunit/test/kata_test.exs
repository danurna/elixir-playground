defmodule BankKataTest do 
  use ExUnit.Case

  test 'deposits money' do
    order = {~D[2019-08-25], :deposit, 10}
    assert Bank.issue(Account.new(), order) == Account.new([order])
  end
  
  test 'withdraws money' do
    initial_order = {~D[2019-08-25], :deposit, 10}
    order = {~D[2019-08-25], :withdraw, 5}
    assert Bank.issue(Account.new([initial_order]), order) == Account.new([order, initial_order])
  end

  test 'withdraws money without sufficient funds fails' do
    order = {~D[2019-08-25], :withdraw, 5}
    assert Bank.issue(Account.new(), order) == {:error, "Insufficient funds"}
  end
  
  """
  it "deposits money" $ do 
    runIdentity (execStateT (deposit 100) newBank) `shouldBe` [Deposit 100] 
  """
end 
