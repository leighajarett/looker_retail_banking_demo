view: portfolio {
  sql_table_name: looker-private-demo.investment_management.PORTFOLIO ;;

  dimension: inst_id_ref {
    type: string
    sql: ${TABLE}.inst_id_ref ;;
  }

  dimension: parent_pos_id_ref {
    type: string
    sql: ${TABLE}.parent_pos_id_ref ;;
  }

  dimension: pos_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.pos_id ;;
  }

  dimension: pos_name {
    type: string
    sql: ${TABLE}.pos_name ;;
  }

  dimension: pos_units {
    type: number
    sql: ${TABLE}.pos_units ;;
  }

  dimension_group: session {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.session_date ;;
  }

  measure: count {
    type: count
    drill_fields: [pos_name]
  }

  measure: average {
    type: average
    sql: ${pos_units} ;;
  }
}
