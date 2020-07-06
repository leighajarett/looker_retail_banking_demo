# scenario could be a drop-down, and theoval_ts{00 --> 29} could be a dropdown, and SESSION_DATE
# Portfolio has IDs, those IDs join to the SIM table IDs, and you would have some sort of aggregate view that would consider the position units size and multiply that against the value.
# Left side should be the tree-view of a portfolio hierarchy. Right side should be one of many choices of reports using the drop down selectors (or hardcoded to some choice for each to prototype quickly)
# Ideally a user would be able to select a portfolio at the root node, or be able to select any sub-portfolio below. Selecting a subportfolio below would narrow the set of instruments shown on the report to the right side with only instruments referenced by that sub-portfolio.

view: sim_selector {
  #this is for only being able to select one scenario and one theoval
  sql_table_name: looker-private-demo.investment_management.SIM_20K_250scen_30ts ;;

  dimension: inst_id {
    label: "Instance ID"
    type: string
    sql: ${TABLE}.inst_id ;;
  }

  dimension: inst_name {
    label: "Instance Name"
    type: string
    sql: ${TABLE}.inst_name ;;
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

  parameter: theoval_selector {
    #here we can hardcode
    type: unquoted
#     suggestions: ["theoval_ts_00", "theoval_ts_01", "theoval_ts_02","theoval_ts_03","theoval_ts_04", "theoval_ts_05"]
    allowed_value: {
      value: "theoval_ts_00"
      label: "00"
    }
    allowed_value: {
      value: "theoval_ts_01"
      label: "01"
    }
    allowed_value: {
      value: "theoval_ts_02"
      label: "02"
    }
    allowed_value: {
      value: "theoval_ts_03"
      label: "03"
    }
    allowed_value: {
      value: "theoval_ts_04"
      label: "04"
    }
  }

  parameter: scenario_selector {
    type: unquoted
    allowed_value: {
      value: "scen_000"
      label: "00"
    }
    allowed_value: {
      value: "scen_001"
      label: "01"
    }
    allowed_value: {
      value: "scen_002"
      label: "02"
    }
    allowed_value: {
      value: "scen_003"
      label: "03"
    }
    allowed_value: {
      value: "scen_004"
      label: "04"
    }
  }


  dimension: theoval {
    hidden: yes
    type: string
    sql: ${TABLE}.{% parameter theoval_selector %} ;;
  }

  dimension: scenario {
    #scen
    type: string
    sql: ${theoval}.{% parameter scenario_selector %} ;;
  }

  dimension: value {
    type: number
    sql: cast(${scenario} as float64);;
  }

#   dimension: instrument {
#     #oval
#     type: string
#     sql: ${TABLE}.instrument;;
#   }

  dimension: pos_value {
    type: number
    sql: ${value} * ${portfolio.pos_units} ;;
  }

  measure: count {
    label: "Number of Instrument / Day Predictions"
    type: count
    drill_fields: [inst_name]
  }

  measure: lowest_value {
    type: min
    sql: ${pos_value} ;;
  }

  measure: highest_value {
    type: max
    sql: ${pos_value} ;;
  }

  measure: average_value {
    type: average
    sql: ${pos_value} ;;
  }

}


#how often are you looking at at things like total from all the scenarios within theoval_09,

# #Unnested theoval Column
# view: oval {
#
#   #   dimension: scen_000 {
#   #     type: number
#   #     sql: ${TABLE}.scen_000 ;;
#   #   }
#   #
#   #   dimension: scen_001 {
#   #     type: number
#   #     sql: ${TABLE}.scen_001 ;;
#   #   }
#
#   dimension: struct {
#     sql: struct('entered_name' as ) ;;
#   }
#
#   measure:  array {
#     type: list
#   }
#
# }
