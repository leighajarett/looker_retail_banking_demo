view: client_fact {
  derived_table: {
    explore_source: account {
      column: client_id {field: client.client_id}
      column: number_of_credit_cards {field: card.number_of_credit_cards}
      bind_all_filters: yes
    }
  }

  dimension: client_id {}

  dimension: number_of_credit_cards {}

}
