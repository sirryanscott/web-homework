defmodule Homework.MerchantsResolverTest do
  use Homework.DataCase

  alias Homework.Merchants
  alias HomeworkWeb.Resolvers.MerchantsResolver

  describe "merchants" do
    alias Homework.Merchants.Merchant

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name"
    }
    @invalid_attrs %{description: nil, name: nil}

    def merchant_fixture(attrs \\ %{}) do
      {:ok, merchant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Merchants.create_merchant()

      merchant
    end

    test "MerchantsResolver.merchants/3 returns all merchants" do
      merchant1 = merchant_fixture(@valid_attrs)
      {:ok, merchant2} = MerchantsResolver.merchants([], [], [])
      assert [merchant1] == merchant2
    end

    test "MerchantsResolver.create_merchant/3 creates a new merchant" do
      assert Merchants.list_merchants([]) == []
      assert MerchantsResolver.create_merchant([], @valid_attrs, [])
      assert length(Merchants.list_merchants([])) == 1
    end

    test "MerchantsResolver.update_merchant/3 with valid data updates a new merchant" do

      merchant = merchant_fixture(@valid_attrs)
      {:ok, %Merchant{} = merchant} = MerchantsResolver.update_merchant([], Map.merge(%{id: merchant.id}, @update_attrs), [])

      assert merchant.name == "some updated name"
      assert merchant.description == "some updated description"
    end

    test "MerchantsResolver.update_merchant/3 with invalid data returns error" do

      merchant = merchant_fixture(@valid_attrs)
      {:error, message} = MerchantsResolver.update_merchant([], Map.merge(%{id: merchant.id}, @invalid_attrs), [])
      assert String.contains?(message,"could not update merchant:") 
    end

    test "MerchantsResolver.delete_merchant/3 deletes a new merchant" do

      merchant = merchant_fixture(@valid_attrs)
      MerchantsResolver.delete_merchant([], %{id: merchant.id}, [])
      assert Merchants.list_merchants([]) == []
    end
  end
end
