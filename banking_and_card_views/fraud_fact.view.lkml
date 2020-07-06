# If necessary, uncomment the line below to include explore_source.
# include: "looker-private-demo.retail_banking.model.lkml"

view: fraud_fact {
  derived_table: {
    explore_source: card_transactions {
      column: number_of_fraudulent_transactions {}
      column: account_id { field: account.account_id }
    }
  }
  dimension: number_of_fraudulent_transactions {
    description: "Tells how many fraudulent transactions have occurred"
    type: number
  }
  dimension: account_id {
    value_format: "0"
    type: number
  }
}