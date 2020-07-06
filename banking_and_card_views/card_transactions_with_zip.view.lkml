view: card_transactions_with_zip {
  derived_table: {
    sql: SELECT
          card_transactions.*,
          zip_code AS merchant_zip,
          city as merchant_city, county as merchant_county, state_name as merchant_state
      FROM
          looker-private-demo.retail_banking.card_transactions  AS card_transactions,
          `bigquery-public-data.geo_us_boundaries.zip_codes` AS zip_codes
      WHERE ST_Within(ST_GEOGPOINT((cast(card_transactions.merchant_lon as FLOAT64)),(cast(card_transactions.merchant_lat as FLOAT64))),zip_codes.zip_code_geom)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cc_number {
    type: string
    sql: ${TABLE}.cc_number ;;
  }

  dimension: trans_id {
    type: string
    sql: ${TABLE}.trans_id ;;
  }

  dimension: trans_time {
    type: string
    sql: ${TABLE}.trans_time ;;
  }

  dimension: epoch_time {
    type: string
    sql: ${TABLE}.epoch_time ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: amount {
    description: "Amount that the transaction was for"
    type: number
    sql: cast(${TABLE}.amount as FLOAT64) ;;
    value_format_name: usd
  }

  dimension: is_fraud {
    label: "Possible Fraud"
    description: "Tells whether or not the transaction was predicted to be fraudulent or not"
    type: yesno
    sql: ${TABLE}.is_fraud = '1';;
  }

  dimension: merchant {
    type: string
    sql: ${TABLE}.merchant ;;
  }

  dimension: merchant_lat {
    type: string
    sql: ${TABLE}.merchant_lat ;;
  }

  dimension: merchant_lon {
    type: string
    sql: ${TABLE}.merchant_lon ;;
  }

  dimension: trans_date {
    type: date
    sql: ${TABLE}.trans_date ;;
  }

  dimension: merchant_zip {
    type: string
    sql: ${TABLE}.merchant_zip ;;
    map_layer_name: us_zipcode_tabulation_areas
  }

  dimension: merchant_city {
    type: string
    sql: ${TABLE}.merchant_city ;;
  }

  dimension: merchant_county {
    type: string
    sql: ${TABLE}.merchant_county ;;
  }

  dimension: merchant_state {
    type: string
    view_label: "Card Transactions"
    sql: ${TABLE}.merchant_state ;;
    map_layer_name: us_states
    drill_fields: [merchant_city,merchant_county,merchant_zip]
  }

  measure: total_amount {
    label: "Total Amount for All Transactions"
    value_format_name: usd
    type: sum
    sql: ${amount} ;;
    }

  set: detail {
    fields: [
      cc_number,
      trans_id,
      trans_time,
      epoch_time,
      category,
      amount,
      is_fraud,
      merchant,
      merchant_lat,
      merchant_lon,
      trans_date,
      merchant_zip,
      merchant_city,
      merchant_county
    ]
  }
}