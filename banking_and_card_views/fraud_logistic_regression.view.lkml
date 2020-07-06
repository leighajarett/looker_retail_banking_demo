view: fraud_model_input {
  derived_table: {
    explore_source: card_transactions {
      column: trans_id {}
      column: merchant {}
      column: category {}
      column: amount {}
      column: transaction_distance {}
      column: days_since_signup {}
      column: is_fraud {}
    }
  }
#   dimension: trans_id {
#     label: "Card Transactions Transaction ID"
#   }
#   dimension: merchant {
#     label: "Card Transactions Merchant Name"
#   }
#   dimension: category {
#     label: "Card Transactions Spend Category"
#   }
#   dimension: amount {
#     description: "Amount that the transaction was for"
#     value_format: "$#,##0.00"
#     type: number
#   }
#   dimension: transaction_distance {
#     value_format_name: decimal_2
#     type: distance
#   }
#   dimension: days_since_signup {
#     description: "How many days between the transaction and the signup"
#     type: duration_day
#   }
#   dimension: is_fraud {
#     label: "Card Transactions Possible Fraud (Yes / No)"
#     description: "Tells whether or not the transaction was predicted to be fraudulent or not"
#     type: yesno
#   }
}

view: fraud_logistic_regression_model {
  derived_table: {
    datagroup_trigger: monthly
    sql_create:
      CREATE OR REPLACE MODEL ${SQL_TABLE_NAME}
      OPTIONS(model_type='LOGISTIC_REG',
        AUTO_CLASS_WEIGHTS=TRUE) AS
      SELECT
         * EXCEPT(trans_id)
      FROM ${fraud_model_input.SQL_TABLE_NAME};;
  }
}
