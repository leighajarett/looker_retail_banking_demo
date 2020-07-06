connection: "looker-private-demo"

include: "/banking_and_card_views/*.view.lkml"
include: "/geo_views/*.view.lkml"
include: "/dashboards/*.dashboard"

include:"retail_banking_explores.lkml"

map_layer: us_census_places {
  file: "/geo_views/city_limits.json"
  property_key: "places"
}

persist_for: "24 hours"


explore: account {
  label: "Accounts, Loans and Cards"
  join: district {
    relationship: many_to_one
    sql_on: ${account.district_id} = ${district.district_id} ;;
  }
  join: loan {
    relationship: one_to_many
    sql_on: ${account.account_id} = ${loan.account_id} ;;
  }
  join: disp {
    relationship: one_to_many
    sql_on: ${account.account_id} = ${disp.account_id} ;;
  }
  join: card {
    type: full_outer
    relationship: one_to_one
    sql_on: ${disp.disp_id} = ${card.disp_id} ;;
  }
  join: client {
    relationship: one_to_one
    sql_on: ${disp.client_id} = ${client.client_id} ;;
  }
  join: client_fact {
    view_label: "Client"
    fields: [client_fact.number_of_credit_cards]
    relationship: one_to_one
    sql_on: ${client.client_id} = ${client_fact.client_id} ;;
  }
}


explore: trans {
  fields: [ALL_FIELDS*, -client.has_loan, -client.number_of_clients_with_loans, -client.percent_clients_with_loans]
  label: "Account Transactions"
  join: account {
    relationship: many_to_one
    sql_on: ${trans.account_id} = ${account.account_id} ;;
  }
  join: disp {
    relationship: one_to_many
    sql_on: ${account.account_id} = ${disp.account_id} ;;
  }
  join: card {
    relationship: one_to_one
    sql_on: ${disp.disp_id} = ${card.disp_id} ;;
  }
  join: district {
    relationship: many_to_one
    sql_on: ${account.district_id} = ${district.district_id} ;;
  }
  join: client {
    relationship: one_to_one
    sql_on: ${disp.client_id} = ${client.client_id} ;;
  }
}

explore: card_transactions {
  fields: [ALL_FIELDS*, -client.has_loan, -client.number_of_clients_with_loans, -client.percent_clients_with_loans, -client.number_of_clients_with_cards,
    -client.percent_clients_with_cards]
  join: card {
    relationship: many_to_one
    sql_on: ${card.card_number} = ${card_transactions.cc_number} ;;
  }
  join: disp {
    relationship: one_to_many
    sql_on: ${card.disp_id} = ${disp.disp_id} ;;
  }
  join: client {
    relationship: one_to_one
    sql_on: ${disp.client_id} = ${client.client_id} ;;
  }
  join: transaction_distance_calculation {
    relationship: one_to_one
    sql_on: ${client.client_id} = ${transaction_distance_calculation.client_id} ;;
  }
  join: account {
    relationship: many_to_one
    sql_on: ${account.account_id} = ${disp.account_id} ;;
  }
}



explore: card_payments {
  fields: [ALL_FIELDS*, -card.days_between_account_signup, -client.has_loan, -client.number_of_clients_with_loans, -client.percent_clients_with_loans]
  join: card_payment_dates {
    relationship: many_to_one
    sql_on: ${card_payments.card_id} = ${card_payment_dates.card_id} and ${card_payments.period_start_raw} = ${card_payment_dates.period_start_raw} ;;
  }
  join: card {
    relationship: many_to_one
    sql_on: ${card.card_id} = ${card_payments.card_id} ;;
  }
  join: card_type {
    relationship: many_to_one
    sql_on: ${card.type} = ${card_type.type} ;;
  }
  join: disp {
    relationship: many_to_one
    sql_on: ${card.disp_id} = ${disp.disp_id} ;;
  }
  join: account {
    relationship: many_to_one
    sql_on: ${disp.account_id} = ${account.account_id} ;;
  }
  join: client {
    relationship: one_to_one
    sql_on: ${client.client_id} = ${disp.client_id} ;;
  }
}



explore: card_order_sequence {
  fields: [ALL_FIELDS*, -card_order_sequence.days_between_account_signup, -repeat_card_purchase.days_between_account_signup,
            -second_repeat_card_purchase.days_between_account_signup,-card_order_sequence.months_between_signup, -second_repeat_card_purchase.months_between_signup,
            -client.has_card,-client.has_loan,-client.number_of_clients_with_loans, -client.percent_clients_with_loans,-client.number_of_clients_with_cards,
    -client.percent_clients_with_cards]
  join: repeat_card_purchase {
    view_label: "Repeat Card Purchase"
    from: card_order_sequence
    relationship: one_to_many
    type: left_outer
    sql_on: ${card_order_sequence.client_id} = ${repeat_card_purchase.client_id}
    and ${card_order_sequence.customer_card_sequence} < ${repeat_card_purchase.customer_card_sequence};;
  }
  join: second_repeat_card_purchase {
    view_label: "Second Repeat Card Purchase"
    from: card_order_sequence
    relationship: one_to_many
    type: left_outer
    sql_on: ${second_repeat_card_purchase.client_id} = ${repeat_card_purchase.client_id}
      and ${repeat_card_purchase.customer_card_sequence} < ${second_repeat_card_purchase.customer_card_sequence};;
  }
  join: disp {
    relationship: one_to_one
    sql_on: ${card_order_sequence.disp_id} = ${disp.disp_id}  ;;
  }
  join: account {
    relationship: many_to_one
    sql_on: ${disp.account_id} = ${account.account_id} ;;
  }
  join: client {
    relationship: one_to_one
    sql_on: ${disp.client_id} = ${client.client_id} ;;
  }
}

#
# explore: card_order_sequence {
#   join: repeat_card_purchase {
#     from: card_order_sequence
#     relationship: many_to_one
#     type: left_outer
#     sql_on: ${card_order_sequence.client_id} = ${repeat_card_purchase.client_id}
#     and ${card_order_sequence.customer_card_sequence} < ${repeat_card_purchase.customer_card_sequence};;
#   }
#   join: third_repeat_card {
#     from: card_order_sequence
#     relationship: many_to_one
#     type: left_outer
#     sql_on: ${repeat_card_purchase.client_id} = ${third_repeat_card.client_id}
#     and ${repeat_card_purchase.customer_card_sequence} < ${third_repeat_card.customer_card_sequence};;
#   }
# }




### location explores
explore: banks_by_zip {
  #view_name: utah_banks_by_zip
}

explore: acs_changes_2011_2017  {
  #view_name: utah_acs_changes_2011_2017
}

explore: acs_2017_zipcodes {
  #view_name: utah_acs_2017_zipcodes
}

explore: acs_2011_zipcodes {
  #view_name: utah_acs_2011_zipcodes
}

explore: acs_2017_zipcodes_and_banks {
  #view_name:  utah_acs_2017_zipcodes_and_banks

}

explore: card_transactions_with_zip {}
