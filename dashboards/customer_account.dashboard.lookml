# - dashboard: customer_account
#   title: Customer Account
#   layout: newspaper
#   embed_style:
#     background_color: "#ffffff"
#     show_title: false
#     title_color: "#3a4245"
#     show_filters_bar: false
#     tile_text_color: "#3a4245"
#     text_tile_text_color: ''
#   elements:
#   - title: Transactions This Month
#     name: Transactions This Month
#     model: retail_banking
#     explore: trans
#     type: single_value
#     fields: [trans.total_transaction_value]
#     filters:
#       trans.account_id: ''
#     sorts: [trans.total_transaction_value]
#     limit: 500
#     query_timezone: America/Los_Angeles
#     custom_color_enabled: true
#     show_single_value_title: true
#     show_comparison: false
#     comparison_type: value
#     comparison_reverse_colors: false
#     show_comparison_label: true
#     enable_conditional_formatting: false
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     hidden_fields: []
#     series_types: {}
#     y_axes: []
#     defaults_version: 1
#     listen:
#       Account ID: account.account_id
#       Transaction Date: trans.transaction_date
#     row: 2
#     col: 6
#     width: 6
#     height: 4
#   - title: Latest Balance
#     name: Latest Balance
#     model: retail_banking
#     explore: trans
#     type: single_value
#     fields: [trans.trans_id, trans.transaction_date, trans.category, trans.amount,
#       trans.balance, trans.account, trans.type, trans.total_transaction_value]
#     filters:
#       trans.account_id: ''
#     sorts: [trans.transaction_date desc]
#     limit: 500
#     query_timezone: America/Los_Angeles
#     hidden_fields: [trans.trans_id, trans.transaction_date, trans.category, trans.amount,
#       trans.account, trans.type, trans.total_transaction_value]
#     series_types: {}
#     y_axes: []
#     listen:
#       Account ID: account.account_id
#       Transaction Date: trans.transaction_date
#     row: 2
#     col: 18
#     width: 6
#     height: 4
#   - title: Recent Transactions
#     name: Recent Transactions
#     model: retail_banking
#     explore: trans
#     type: looker_grid
#     fields: [trans.trans_id, trans.transaction_date, trans.category, trans.amount,
#       trans.balance, trans.type, trans.total_transaction_value]
#     filters:
#       trans.account_id: ''
#       trans.transaction_date: before 0 days ago
#     sorts: [trans.transaction_date desc]
#     limit: 20
#     dynamic_fields: [{table_calculation: value, label: Value, expression: "${trans.total_transaction_value}",
#         value_format: !!null '', value_format_name: eur, _kind_hint: measure, _type_hint: number,
#         is_disabled: true}]
#     query_timezone: America/Los_Angeles
#     show_view_names: false
#     show_row_numbers: false
#     transpose: false
#     truncate_text: true
#     hide_totals: false
#     hide_row_totals: false
#     size_to_fit: true
#     table_theme: white
#     limit_displayed_rows: false
#     enable_conditional_formatting: false
#     header_text_alignment: left
#     header_font_size: '12'
#     rows_font_size: '12'
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     show_sql_query_menu_options: false
#     show_totals: true
#     show_row_totals: true
#     series_labels:
#       value: _
#       trans.total_transaction_value: Value
#     series_column_widths:
#       trans.total_transaction_value: 100
#     series_cell_visualizations:
#       trans.total_transaction_value:
#         is_active: false
#         value_display: true
#       value:
#         is_active: true
#         value_display: false
#     series_text_format:
#       trans.total_transaction_value:
#         bold: true
#         align: right
#       trans.balance:
#         bold: true
#         align: right
#     series_value_format:
#       trans.trans_id:
#         name: id
#         format_string: '0'
#         label: ID
#       trans.account:
#         name: id
#         format_string: '0'
#         label: ID
#     series_types: {}
#     hidden_fields: [trans.trans_id, trans.account]
#     y_axes: []
#     defaults_version: 1
#     listen:
#       Account ID: account.account_id
#     row: 6
#     col: 0
#     width: 10
#     height: 8
#   - title: Average Balance
#     name: Average Balance
#     model: retail_banking
#     explore: trans
#     type: single_value
#     fields: [trans.average_account_balance_during_transaction]
#     limit: 500
#     query_timezone: America/Los_Angeles
#     custom_color_enabled: true
#     show_single_value_title: true
#     show_comparison: false
#     comparison_type: value
#     comparison_reverse_colors: false
#     show_comparison_label: true
#     enable_conditional_formatting: false
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     tile_title: Balance Summary
#     highlightColours: ["#31bf4b", "#3EB0D5", "#B1399E", "#592EC2", "#4276BE", "#72D16D",
#       "#FFD95F", "#B32F37", "#9174F0", "#E57947", "#75E2E2", "#FBB555"]
#     textColour: "#1e9623"
#     trans.average_transaction_value: Average Transaction Value
#     trans.average_account_balance: Average Account Balance
#     trans.number_of_transactions: Number of Transactions
#     trans.total_transaction_value: Total Transaction Value
#     series_types: {}
#     hidden_fields: []
#     y_axes: []
#     hidden_points_if_no: []
#     series_labels: {}
#     show_view_names: true
#     defaults_version: 1
#     listen:
#       Account ID: account.account_id
#       Transaction Date: trans.transaction_date
#     row: 2
#     col: 12
#     width: 6
#     height: 4
#   - title: Client Overview
#     name: Client Overview
#     model: retail_banking
#     explore: account
#     type: looker_single_record
#     fields: [account.account_id, client.client_id, client.district_id, client.age,
#       client.gender, card.card_number, loan.loan_id]
#     sorts: [client.age]
#     limit: 500
#     column_limit: 50
#     show_view_names: false
#     series_types: {}
#     defaults_version: 1
#     listen:
#       Account ID: account.account_id
#     row: 2
#     col: 0
#     width: 6
#     height: 4
#   - name: "<span class='fa fa-tachometer'> Account Overview </span>"
#     type: text
#     title_text: "<span class='fa fa-tachometer'> Account Overview </span>"
#     row: 0
#     col: 0
#     width: 24
#     height: 2
#   - title: Balance Over Time
#     name: Balance Over Time
#     model: retail_banking
#     explore: balances_fact
#     type: looker_line
#     fields: [balances_fact.balance_date, balances_fact.total_balance, trans.total_outflow,
#       trans.total_inflow]
#     filters:
#       balances_fact.balance_date: 6 months
#     sorts: [balances_fact.balance_date desc]
#     limit: 500
#     column_limit: 50
#     x_axis_gridlines: false
#     y_axis_gridlines: false
#     show_view_names: false
#     show_y_axis_labels: true
#     show_y_axis_ticks: true
#     y_axis_tick_density: default
#     y_axis_tick_density_custom: 5
#     show_x_axis_label: false
#     show_x_axis_ticks: true
#     y_axis_scale_mode: linear
#     x_axis_reversed: false
#     y_axis_reversed: false
#     plot_size_by_field: false
#     trellis: ''
#     stacking: ''
#     limit_displayed_rows: false
#     legend_position: center
#     point_style: none
#     show_value_labels: false
#     label_density: 25
#     x_axis_scale: auto
#     y_axis_combined: true
#     show_null_points: true
#     interpolation: monotone
#     y_axes: [{label: '', orientation: left, series: [{axisId: trans.total_outflow,
#             id: trans.total_outflow, name: Total Outflow}, {axisId: trans.total_inflow,
#             id: trans.total_inflow, name: Total Inflow}], showLabels: true, showValues: true,
#         unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
#       {label: !!null '', orientation: right, series: [{axisId: balances_fact.total_balance,
#             id: balances_fact.total_balance, name: Total Balance}], showLabels: true,
#         showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
#         type: linear}]
#     series_types: {}
#     series_colors:
#       trans.total_outflow: "#B32F37"
#       trans.total_inflow: "#72D16D"
#       balances_fact.total_balance: "#4276BE"
#     series_point_styles:
#       balances_fact.total_balance: diamond
#     defaults_version: 1
#     hidden_fields: []
#     listen:
#       Account ID: account.account_id
#     row: 6
#     col: 10
#     width: 14
#     height: 8
#   filters:
#   - name: Account ID
#     title: Account ID
#     type: field_filter
#     default_value: '8261'
#     allow_multiple_values: true
#     required: false
#     model: retail_banking
#     explore: trans
#     listens_to_filters: []
#     field: account.account_id
#   - name: Transaction Date
#     title: Transaction Date
#     type: field_filter
#     default_value: 1 months
#     allow_multiple_values: true
#     required: false
#     model: retail_banking
#     explore: trans
#     listens_to_filters: []
#     field: trans.transaction_date
