view: card_transactions {
  sql_table_name: `looker-private-demo.retail_banking.card_transactions` ;;

  dimension: amount {
    description: "Amount that the transaction was for"
    type: number
    sql: cast(${TABLE}.amount as FLOAT64) ;;
    value_format_name: usd
  }

  dimension: category {
    drill_fields: [subcategory,merchant,transaction_day_of_week, transaction_hour_of_day]
    label: "Spend Category"
    type: string
    sql: case when ${subcategory} like '%shopping%'  then 'Shopping' when ${subcategory} like '%grocery%' then 'Grocery'
            when ${subcategory} like '%entertainment%' then 'Entertainment'
            when ${subcategory} like '%health%'  or ${subcategory} like '%personal%' then 'Health & Personal Care'
            when ${subcategory} like '%food%' then 'Food & Dining' when ${subcategory} like '%gas%' then 'Gas & Transport'
            when ${subcategory} like '%travel%' then 'Travel' when ${subcategory} like '%home%'  then 'Home' else 'Miscellaneous' end
            ;;
  }

  dimension: subcategory {
    hidden: yes
    type: string
    sql: ${TABLE}.category;;
  }

#   dimension: category_clean {
#     type: string
#     sql:  ;;
#   }

  dimension: cc_number {
    hidden: yes
    view_label: "Credit Card"
    label: "Credit Card Number"
    type: string
    sql: ${TABLE}.cc_number ;;
  }

  dimension: is_fraud {
    label: "Possible Fraud"
    description: "Tells whether or not the transaction was predicted to be fraudulent or not"
    type: yesno
    sql: ${TABLE}.is_fraud = '1';;
  }

  measure: number_of_fraudulent_transactions {
    description: "Tells how many fraudulent transactions have occurred"
    type: count
    filters: {
      field: is_fraud
      value: "yes"
    }
  }

  measure: number_of_legitimate_transactions {
    description: "Tells how many fraudulent transactions have occurred"
    type: count
    filters: {
      field: is_fraud
      value: "no"
    }
  }

  dimension: merchant {
    label: "Merchant Name"
    type: string
    sql: ${TABLE}.merchant ;;
#     link: {
#       label: "Merchant Review Dashboard"
#       url: "this is a placeholder"
#     }
    link: {
      icon_url: "https://www.konfest.com/wp-content/uploads/2019/05/Konfest-PNG-JPG-Image-Pic-Photo-Free-Download-Royalty-Unlimited-clip-art-sticker-world-wide-web-icons-website-earth-grid-globe-black-white-24.png"
      label: "Go to Merchant Website"
      url: "this is a placehoder"
    }
    link: {
      icon_url: "https://f0.pngfuel.com/png/312/936/red-and-blue-stop-sign-nicaragua-google-maps-navigation-map-icon-png-clip-art.png"
      label: "Find Merchant on Google Maps"
      url: "this is a placeholder"
    }
    action: {
      label: "Create Points Campaign with Merchant"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Possible Points Campaign with {{ value }}"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "
        I'm thinking that partnering with {{ value }} to offer 2x points on all purchases may be a good way to get more traction on the Emerald card.

        What do you think?"
      }
    }
    link: {
      label: "{{value}} Deep-Dive Dashboard"
      url: "/dashboards-next/442?Merchant%20Name={{ value | encode_uri }}"
      icon_url: "https://t4.ftcdn.net/jpg/03/32/61/47/240_F_332614727_hbL8NEDgMnlBzAHWDxU0v3qRNEu7kxTH.jpg"
    }
  }

  dimension: merchant_lat {
    hidden: yes
    type: number
    sql: cast(${TABLE}.merchant_lat as FLOAT64);;
  }

  dimension: merchant_lon {
    hidden: yes
    type: number
    sql: cast(${TABLE}.merchant_lon as FLOAT64) ;;
  }

  dimension: client_lon {
    type: number
    sql: client.lon ;;
    hidden: yes
  }

  dimension: merchant_geom {
    type: string
    sql: ST_GEOGPOINT(${merchant_lon},${merchant_lat}) ;;
    hidden: yes
  }

  dimension: merchant_coordinates {
    type: string
    sql: concat(${merchant_lat},", ",${merchant_lon}) ;;
    hidden: yes
  }

  dimension: test_transaction_distance {
    type: number
    sql: ST_DISTANCE(${merchant_geom},${client.client_geom}) ;;
  }

  dimension: merchant_location {
    type: location
    sql_latitude: ${merchant_lat} ;;
    sql_longitude: ${merchant_lon} ;;
  }

  dimension: merchant_address_street_view {
    type: string
    sql: ${merchant_coordinates} ;;
    html: <img src="https://maps.googleapis.com/maps/api/streetview?size=700x400&location={{value | encode_uri}}&fov=120&key=AIzaSyD7BvCbKqjStBl7r6AmDu1p8yGF-IxtFLs" ;;
  }

  dimension: transaction_distance {
    type: distance
    start_location_field:  client.location
    end_location_field: merchant_location
    units: miles

  }

  dimension: transaction_distance_tier {
    type: tier
    tiers: [20,40,60,80,100]
    style: integer
    sql: ${transaction_distance} ;;
  }

  measure: average_transaction_distance {
    type: average
    value_format_name: decimal_2
    sql: ${transaction_distance} ;;

  }

  dimension: is_fraud_percentile {
    type: yesno
    sql: ${transaction_distance} > ${transaction_distance_calculation.percentile90} ;;
  }

  dimension: trans_date {
    hidden: yes
    type: string
    sql: ${TABLE}.trans_date ;;
  }

  dimension: trans_id {
    label: "Transaction ID"
    primary_key: yes
    type: string
    sql: ${TABLE}.trans_id ;;
    link: {
      label: "Transaction Deep-Dive Dashboard"
      url: "/dashboards-next/425?Transaction%20ID={{ value | encode_uri }}"
      icon_url: "https://image.flaticon.com/icons/svg/2856/2856957.svg"
    }
    action: {
      label: "Send this to fraud investigator"
      url: "https://hooks.zapier.com/hooks/catch/1662138/tvc3zj/"
      form_param: {
        name: "Message"
        type: textarea
        default: "Hey,
        Could you check out transaction #{{value}}. The customer is reaching out to us about it to report fraud.
        ~{{ _user_attributes.first_name}}"
      }
      form_param: {
        name: "Recipient"
        type: select
        default: "zevl"
        option: {
          name: "zevl"
          label: "Zev"
        }
        option: {
          name: "slackdemo"
          label: "Slack Demo User"
        }
      }
      form_param: {
        name: "Channel"
        type: select
        default: "cs"
        option: {
          name: "cs"
          label: "Fraud Department"
        }
        option: {
          name: "general"
          label: "General"
        }
      }
    }

  }

  dimension: trans_time {
    hidden: yes
    type: string
    sql: ${TABLE}.trans_time ;;
  }

  dimension_group: transaction {
    type: time
    sql: TIMESTAMP(CONCAT(${trans_date},' ',${trans_time})) ;;
    convert_tz: no
  }

  dimension: days_before_cancellation {
    description: "If the card was canceled, how many days before the cancellation did the transaction occur"
    type: duration_day
    sql_start: ${card.end_raw};;
    sql_end:${transaction_raw};;
  }

  dimension: months_since_signup {
    description: "How many months between the transaction and the signup"
    type: duration_month
    sql_start: ${card.create_raw};;
    sql_end:${transaction_raw};;
  }


  dimension: days_since_signup {
    description: "How many days between the transaction and the signup"
    type: duration_day
    sql_start: ${card.create_raw};;
    sql_end:${transaction_raw};;
  }

  measure: count {
    label: "Number of Transactions"
    type: count
    drill_fields: [transaction_date, transaction_day_of_week, transaction_time_of_day, client.name, cc_number, card.type, merchant, category, total_amount]
  }

  ##additional metrics

  measure: average_amount {
    label: "Average Amount per Transaction"
    value_format_name: usd
    type: average
    sql: ${amount} ;;
  }

  measure: total_amount {
    label: "Total Amount for All Transactions"
    value_format_name: usd
    type: sum
    sql: ${amount} ;;
    drill_fields: [transaction_date, transaction_day_of_week, transaction_time_of_day, client.name, cc_number, card.type, merchant, category, total_amount]
  }

  measure: cards {
    hidden: yes
    type: count_distinct
    sql: ${cc_number} ;;
  }

  measure: first_transaction {
    type: date_time
    sql: min(${transaction_raw}) ;;
  }

  measure: last_transaction {
    type: date_time
    sql: max(${transaction_raw}) ;;
  }

  measure: average_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
  }

# measure: total_fraudulent_transactions {
#   type: count_distinct
#   filters: [is_fraud: "1"]
# }

##additional metrics

  dimension: reporting_period {
    sql: CASE
        WHEN EXTRACT(MONTH from ${transaction_raw}) = EXTRACT(MONTH from CURRENT_TIMESTAMP())
        AND ${transaction_raw} < CURRENT_TIMESTAMP()
        THEN 'This Month to Date'

        WHEN EXTRACT(MONTH from ${transaction_raw}) + 1 = EXTRACT(MONTH from CURRENT_TIMESTAMP())
        AND CAST(FORMAT_TIMESTAMP('%j', ${transaction_raw}) AS INT64) <= CAST(FORMAT_TIMESTAMP('%j', CURRENT_TIMESTAMP()) AS INT64)
        THEN 'Last Month to Date'

      END
       ;;
  }
}
