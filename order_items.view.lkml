view: order_items {
  sql_table_name: public.order_items ;;

#   parameter: p_period {
#     label: "Date Period Selection"
#     type: string
#     allowed_value: { label: "Date" value: "date"}
#     allowed_value: { label: "Month" value: "month" }
#     allowed_value: { label: "Quarter" value: "quarter" }
#     default_value: "month"
#   }

  parameter: dummy_measure_filter {
    allowed_value: {value:"Total Revenue"}
    allowed_value: {value:"Total Profit"}
    allowed_value: {value:"Average Sales Price"}
  }

  parameter: dynamic_function {
    type: unquoted
    allowed_value: { label: "Sum" value: "SUM" }
    allowed_value: { label: "Average" value: "AVG" }
    allowed_value: { label: "Count" value: "COUNT" }
  }

#   filter: f_range {
#     label: "Date Range Selection"
#     type: date
#   }

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    description: "When the order was created"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    description: "When the order was delivered"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
    description: "When the order was returned"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    description: "When the order was shipped"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    description: "Whether order is processing, shipped, completed, etc."
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: shipping_time {
    description: "Shipping time in days"
    type: number
    sql: DATEDIFF(day, ${order_items.shipped_date}, ${order_items.delivered_date}) ;;
  }

## HIDDEN DIMENSIONS ##

  dimension: inventory_item_id {
    hidden:  yes
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
#     hidden:  yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: profit {
    description: "Profit made on any one item"
    hidden:  yes
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

## MEASURES ##
  measure: dummy_measure {
    type: number
    sql: case when {% parameter dummy_measure_filter %} = 'Total Revenue' then ${total_revenue}
       when {% parameter dummy_measure_filter %} = 'Total Profit' then ${total_profit}
      when {% parameter dummy_measure_filter %} = 'Average Sales Price' then ${total_revenue}
      else null end ;;
  }

  measure: users_aggregation {
    label: "User's Aggregation"
    type: number
    sql: {% parameter dynamic_function %}(${sale_price}) ;;
  }

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    hidden: yes
  }

  measure: order_count {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
    hidden: yes
  }

#   measure: count_orders_made_in_user_range {
#     type: number
#     sql: COUNT(DISTINCT CASE WHEN {% condition f_range %} ${created_date} {% endcondition %}
#               THEN order_id
#               else null end) ;;
#   }

  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [order_info*]
    hidden: no
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_revenue} / NULLIF(${users.count},0) ;;
    hidden: yes
  }

  measure: total_profit {
    type: sum
    sql: ${profit} ;;
    value_format_name: usd
    hidden: yes
  }

  measure: profit_margin {
    type: number
    sql: ${total_profit}/NULLIF(${total_revenue}, 0) ;;
    value_format_name: percent_2
    hidden: yes
  }

  measure: average_shipping_time {
    type: average
    sql: ${shipping_time} ;;
    value_format: "0\" days\""
    hidden: yes
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

  set: order_info {
    fields: [order_id, created_date, total_revenue]
  }

  set: external_ref {
    fields: [average_spend_per_user]
  }
}
