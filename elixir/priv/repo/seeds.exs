# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Homework.Users.User
alias Homework.Transactions.Transaction
alias Homework.Merchants.Merchant
alias Homework.Companies.Company

#
# populate Companies table
#
Homework.Repo.insert!(%Company{
    id: "a0bbd2a1-dac7-427e-9d92-38e476bb832c",
    name: "Company 1",
    credit_line: 10000,
    available_credit: 8000
})
Homework.Repo.insert!(%Company{
    id: "a0bbd2a1-dac7-427e-9d92-38e476bb832b",
    name: "Company 2",
    credit_line: 15000,
    available_credit: 12500
})

#
# populate User table
#
Homework.Repo.insert!(%User{
    id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
    dob: "04/03/1972",
    first_name: "Thomas",
    last_name: "Clark",
    company_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832c",
})
Homework.Repo.insert!(%User{
    dob: "07/04/1994",
    first_name: "Paul",
    last_name: "Johnson",
    company_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832c",
})
Homework.Repo.insert!(%User{
    dob: "10/17/1989",
    first_name: "Jordan",
    last_name: "Witcomb",
    company_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832b",
})
Homework.Repo.insert!(%User{
    dob: "09/07/1965",
    first_name: "Bjorn",
    last_name: "Borgensson",
    company_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832b",
})


##
## populate Merchant table
##
Homework.Repo.insert!(%Merchant{
    name: "Costco",
    description: "Costco Warehouse"
})
Homework.Repo.insert!(%Merchant{
    id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    name: "Walmart",
    description: "Walmart Supercenter"
})
Homework.Repo.insert!(%Merchant{
    name: "Home Depot",
    description: "Hardware Store"
})


#
# populate Transaction table
#
Homework.Repo.insert!(%Transaction{
    amount: 100, 
    credit: false,
    debit: true,
    description: "clothes",
    merchant_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    user_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
})
Homework.Repo.insert!(%Transaction{
    amount: 15,
    credit: false,
    debit: true,
    description: "movie tickets",
    merchant_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    user_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
})
Homework.Repo.insert!(%Transaction{
    amount: 4567,
    credit: false,
    debit: true,
    description: "grocery visit",
    merchant_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    user_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
})
Homework.Repo.insert!(%Transaction{
    amount: 2,
    credit: true,
    debit: false,
    description: "paying back for ice cream cone",
    merchant_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    user_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
})
Homework.Repo.insert!(%Transaction{
    amount: 3726,
    credit: true,
    debit: false,
    description: "return for that broken item",
    merchant_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832d",
    user_id: "a0bbd2a1-dac7-427e-9d92-38e476bb832e",
})

