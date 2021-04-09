defmodule Homework.UsersResolverTest do
  use Homework.DataCase

  alias Homework.Users
  alias Homework.Companies
  alias HomeworkWeb.Resolvers.UsersResolver

  describe "users" do
    alias Homework.Users.User

    setup do
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

      valid_attrs = %{
          dob: "some dob",
          first_name: "some first_name",
          last_name: "some last_name",
          company_id: company1.id
        }

      update_attrs = %{
          dob: "some updated dob",
          first_name: "some updated first_name",
          last_name: "some updated last_name",
          company_id: company2.id
        }

      invalid_attrs = %{
          dob: nil,
          first_name: nil,
          last_name: nil,
          company_id: nil
      }

      {:ok,
       %{
         valid_attrs: valid_attrs,
         update_attrs: update_attrs,
         invalid_attrs: invalid_attrs,
         company1: company1,
         company2: company2,
       }}
    end

    def user_fixture(valid_attrs, attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(valid_attrs)
        |> Users.create_user()

      user
    end

    test "UsersResolver.users/3 returns all users", %{valid_attrs: valid_attrs} do
      user1 = user_fixture(valid_attrs)
      {:ok, user2} = UsersResolver.users([], [], [])
      assert [user1] == user2
    end

    test "UsersResolver.create_user/3 creates a new user", %{valid_attrs: valid_attrs} do
      assert Users.list_users([]) == []
      assert UsersResolver.create_user([], valid_attrs, [])
      assert length(Users.list_users([])) == 1
    end

    test "UsersResolver.update_user/3 with valid data updates a new user", %{
      valid_attrs: valid_attrs,
      update_attrs: update_attrs,
      company2: company2
    } do

      user = user_fixture(valid_attrs)
      {:ok, %User{} = user} = UsersResolver.update_user([], Map.merge(%{id: user.id}, update_attrs), [])

      assert user.dob == "some updated dob"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.company_id == company2.id
    end

    test "UsersResolver.update_user/3 with invalid data returns error", %{
      valid_attrs: valid_attrs,
      invalid_attrs: invalid_attrs,
    } do

      user = user_fixture(valid_attrs)
      {:error, message} = UsersResolver.update_user([], Map.merge(%{id: user.id}, invalid_attrs), [])
      assert String.contains?(message, "could not update user:")
    end

    test "UsersResolver.delete_user/3 deletes a new user", %{
      valid_attrs: valid_attrs,
    } do

      user = user_fixture(valid_attrs)
      UsersResolver.delete_user([], %{id: user.id}, [])
      assert Users.list_users([]) == []
    end

    test "UsersResolver.company/3 returns company associated with a user", %{
      valid_attrs: valid_attrs,
      company1: company1
    } do
      user = user_fixture(valid_attrs)
      {:ok, company} = UsersResolver.company([], [], %{source: %{company_id: user.company_id}})
      assert company == company1
    end
  end
end
