defmodule Homework.CompaniesResolverTest do
  use Homework.DataCase

  alias Homework.Companies
  alias HomeworkWeb.Resolvers.CompaniesResolver

  describe "companies" do
    alias Homework.Companies.Company

    @valid_attrs %{
      name: "some name", 
      credit_line: 2000, 
      available_credit: 1000
    }
    @update_attrs %{
      name: "some updated name",
      credit_line: 3000, 
      available_credit: 2000
    }
    @invalid_attrs %{
      name: nil,
      credit_line: nil, 
      available_credit: nil 
    }

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "CompaniesResolver.companies/3 returns all companies" do
      company1 = company_fixture(@valid_attrs)
      {:ok, company2} = CompaniesResolver.companies([], [], [])
      assert [company1] == company2
    end

    test "CompaniesResolver.create_company/3 creates a new company" do
      assert Companies.list_companies([]) == []
      assert CompaniesResolver.create_company([], @valid_attrs, [])
      assert length(Companies.list_companies([])) == 1
    end

    test "CompaniesResolver.update_company/3 with valid data updates a new company" do

      company = company_fixture(@valid_attrs)
      {:ok, %Company{} = company} = CompaniesResolver.update_company([], Map.merge(%{id: company.id}, @update_attrs), [])

      assert company.name == "some updated name"
      assert company.credit_line == 3000
      assert company.available_credit == 2000
    end

    test "CompaniesResolver.update_company/3 with invalid data returns error" do

      company = company_fixture(@valid_attrs)
      {:error, message} = CompaniesResolver.update_company([], Map.merge(%{id: company.id}, @invalid_attrs), [])
      assert String.contains?(message, "could not update company:")
    end

    test "CompaniesResolver.delete_company/3 deletes a new company" do

      company = company_fixture(@valid_attrs)
      CompaniesResolver.delete_company([], %{id: company.id}, [])
      assert Companies.list_companies([]) == []
    end
  end
end
