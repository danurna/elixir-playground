defmodule Account do
  def new(), do: []
  def new(orders), do: orders

  def add_order(account, order) do 
    if is_allowed_order(account, order) do
      [order | account]
    else 
      {:error, "Insufficient funds"}
    end
  end

  defp is_allowed_order(account, {_, :deposit, _}) do 
    true
  end

  defp is_allowed_order(account, {_, :withdraw, x}) do 
    if balance(account) >= x, do: true, else: false
  end

  def balance(orders), do: AccountHelper.sum(orders)
end

defmodule AccountHelper do 
  def sum([]), do: 0
  def sum([head | tail]), do: sum(head) + sum(tail)

  def sum({_, :deposit, x}) when is_number(x) and x > 0 do
    x
  end

  def sum({_, :withdraw, x}) when is_number(x) and x > 0 do
    -1*x
  end
end

defmodule DateProvider do 
  @callback get_date() :: Date
end

defmodule Bank do
  def issue(account, order) do
    account
      |> Account.add_order(order)
  end

  def statement(account) do
    account
      |> Account.balance()
      |> IO.puts()
  end

  def transfer(from, to, amount) do 
    from = issue(from, {:withdraw, amount})

    to
      |> issue({:deposit, amount})
  end

  defp mapOrdersToRelativeValue(orders) do
    orders
  end
end

defmodule Main do
  def main do
    account = Account.new()
      |> Bank.issue({~D[2019-08-25], :deposit, 1499})
      |> Bank.issue({~D[2019-08-26], :withdraw, 199})
      |> Bank.issue({~D[2019-08-28], :withdraw, 200})
      |> Bank.statement()

   # Bank.transfer(account, otherAccount, 1000)
  end
end

Main.main
