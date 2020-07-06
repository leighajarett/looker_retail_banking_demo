view: transaction_distance_calculation {
  derived_table: {
    sql: SELECT DISTINCT client_id, percentile90/1609.344 as percentile90_miles FROM (

            SELECT
            client.client_id,card_transactions.trans_id,
            PERCENTILE_CONT(ST_DISTANCE(ST_GEOGPOINT((cast(card_transactions.merchant_lon as FLOAT64)),
              (cast(card_transactions.merchant_lat as FLOAT64))),
              ST_GeogPoint((cast(SPLIT(client.address,'|')[OFFSET(4)] as float64)),
              (cast(SPLIT(client.address,'|')[OFFSET(3)] as float64)))), 0.9)
              OVER(PARTITION BY client.client_id) AS percentile90

            FROM looker-private-demo.retail_banking.card_transactions  AS card_transactions
            LEFT JOIN looker-private-demo.retail_banking.card  AS card ON card.card_number = card_transactions.cc_number
            LEFT JOIN looker-private-demo.retail_banking.disp  AS disp ON card.disp_id = disp.disp_id
            LEFT JOIN looker-private-demo.retail_banking.client  AS client ON disp.client_id = client.client_id)
             ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: client_id {
    type: number
    sql: ${TABLE}.client_id ;;
  }

  dimension: percentile90 {
    type: number
    sql: ${TABLE}.percentile90_miles ;;
  }

  set: detail {
    fields: [client_id, percentile90]
  }
}