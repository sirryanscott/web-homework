defmodule Homework.TransactionsResolverTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies
  alias HomeworkWeb.Resolvers.TransactionsResolver

  describe "transactions" do
    alias Homework.Transactions.Transaction

    setup do
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})

      {:ok, merchant2} =
        Merchants.create_merchant(%{
          description: "some updated description",
          name: "some updated name"
        })

      {:ok, company1} = 
        Companies.create_company(%{
          name: "some company name", 
          credit_line: 2000, 
          available_credit: 1000
        })

      {:ok, company2} = 
        Companies.create_company(%{
          name: "some updated company name", 
          credit_line: 3000, 
          available_credit: 2000
        })

      {:ok, user1} =
        Users.create_user(%{
          dob: "some dob",
          first_name: "some first_name",
          last_name: "some last_name",
          company_id: company1.id
        })

      {:ok, user2} =
        Users.create_user(%{
          dob: "some updated dob",
          first_name: "some updated first_name",
          last_name: "some updated last_name",
          company_id: company2.id
        })

      valid_attrs = %{
        amount: 42,
        credit: true,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id
      }

      update_attrs = %{
        amount: 43,
        credit: false,
        debit: false,
        description: "some updated description",
        merchant_id: merchant2.id,
        user_id: user2.id
      }

      invalid_attrs = %{
        amount: nil,
        credit: nil,
        debit: nil,
        description: nil,
        merchant_id: nil,
        user_id: nil
      }

      {:ok,
       %{
         valid_attrs: valid_attrs,
         update_attrs: update_attrs,
         invalid_attrs: invalid_attrs,
         merchant1: merchant1,
         merchant2: merchant2,
         user1: user1,
         user2: user2
       }}
    end

    def transaction_fixture(valid_attrs, attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "TransactionsResolver.transactions/3 returns all transactions", %{valid_attrs: valid_attrs} do
      transaction = transaction_fixture(valid_attrs)
      transaction_from_db = Transactions.get_transaction!(transaction.id)
      {:ok, all_transactions} = TransactionsResolver.transactions([], [], [])
      assert [transaction_from_db] == all_transactions
    end

    test "TransactionsResolver.create_transaction/3 creates a new transaction", %{valid_attrs: valid_attrs} do
      assert Transactions.list_transactions([]) == []
      assert TransactionsResolver.create_transaction([], valid_attrs, [])
      assert length(Transactions.list_transactions([])) == 1
    end

    test "TransactionsResolver.update_transaction/3 with valid data updates a new transaction", %{
      valid_attrs: valid_attrs,
      update_attrs: update_attrs,
      merchant2: merchant2,
      user2: user2
    } do

      transaction = transaction_fixture(valid_attrs)
      {:ok, %Transaction{} = transaction} = TransactionsResolver.update_transaction([], Map.merge(%{id: transaction.id}, update_attrs), [])

      assert transaction.amount == 4300
      assert transaction.credit == false
      assert transaction.debit == false
      assert transaction.description == "some updated description"
      assert transaction.merchant_id == merchant2.id
      assert transaction.user_id == user2.id
    end

    test "TransactionsResolver.update_transaction/3 with invalid data returns error", %{
      valid_attrs: valid_attrs,
      invalid_attrs: invalid_attrs,
    } do

      transaction = transaction_fixture(valid_attrs)
      {:error, message}= TransactionsResolver.update_transaction([], Map.merge(%{id: transaction.id}, invalid_attrs), [])
      assert String.contains?(message, "could not update transaction:")
    end

    test "TransactionsResolver.delete_transaction/3 deletes a new transaction", %{
      valid_attrs: valid_attrs,
    } do

      transaction = transaction_fixture(valid_attrs)
      TransactionsResolver.delete_transaction([], %{id: transaction.id}, [])
      assert Transactions.list_transactions([]) == []
    end
  end
end
