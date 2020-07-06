connection: "looker-private-demo"

include: "/risk_views/*.view.lkml"                # include all views in the views/ folder in this project
#include: "/dashboards/*.dashboard"


# explore: sim {
#   always_filter: {
#     filters: {
#       field: session_date
#       value: "last 365 days"
#     }
#   }
#   join: oval {
#     sql: LEFT JOIN UNNEST(${array}) as oval;;
#   }
# }


#   SELECT
#    inst_id, inst_name, session_date, theoval_ts_00.oval, theoval_ts_00.scenario, theoval_ts_00.result
#     FROM `looker-private-demo`.investment_management.SIM_20K_250scen_30ts
#     LEFT JOIN
#     UNNEST([
#       STRUCT('theoval_ts_00' AS oval, 'scen232' AS scenario, theoval_ts_00.scen_232 AS result),
#       STRUCT('theoval_ts_00' AS oval, 'scen111' AS scenario, theoval_ts_00.scen_111 AS result),
#       STRUCT('theoval_ts_01' AS oval, 'scen232' AS scenario, theoval_ts_01.scen_232 AS result),
#       STRUCT('theoval_ts_01' AS oval, 'scen111' AS scenario, theoval_ts_01.scen_111 AS result)
#     ]) AS theoval_ts_00
#   where session_date = "2019-07-01"
#}


explore: sim_selector {
  join: portfolio {
    relationship: many_to_one
    sql_on: ${sim_selector.inst_id} = ${portfolio.inst_id_ref} ;;
  }
}

explore: portfolio {
  label: "Portfolio Hierarchy"
  join: child_portfolio {
    relationship: many_to_one
    from: portfolio
    type: left_outer
    sql_on: ${portfolio.pos_id} = ${child_portfolio.parent_pos_id_ref} ;;
  }
  join: grand_child_portfolio {
    relationship: many_to_one
    from: portfolio
    type: left_outer
    sql_on: ${child_portfolio.pos_id} = ${grand_child_portfolio.parent_pos_id_ref} ;;
  }
}
