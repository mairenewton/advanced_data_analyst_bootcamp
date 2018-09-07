view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: dynamic_agg {
    type: unquoted
    allowed_value: {
      label: "minimum"
      value: "MIN"
    }
    allowed_value: {
      label: "total"
      value: "SUM"
    }
  }

  parameter: select_measure_type_parameter {
    label: "Select A Measure"
    type: string
    default_value: "Total Revenue"
    allowed_value: {
      label: "x"
      value: "Total Revenue"
    }
    allowed_value: {
      value: "Order Count"
    }
    allowed_value: {
      value: "Average Sale Price"
    }
  }

  measure: count_of_selected_measure_type {
    label_from_parameter: select_measure_type_parameter
    type: number
    sql: case
          when {% parameter select_measure_type_parameter %} = 'Total Revenue' then SUM(${sale_price})
          when {% parameter select_measure_type_parameter %} = 'Order Count' then ${order_count}
          when {% parameter select_measure_type_parameter %} = 'Average Sale Price' then ${average_sale_price}
              end
          ;;
    value_format_name: decimal_0
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
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
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



## MEASURES ##

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: dynamic_revenue_something {
    type: number
    sql: {% parameter dynamic_agg %}(${sale_price}) ;;
  }

  measure: order_count {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_revenue} / NULLIF(${users.count},0) ;;
  }

  dimension: profit {
    description: "Profit made on any one item"
    hidden:  yes
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  measure: total_profit {
    type: sum
    sql: ${profit} ;;
    value_format_name: usd
  }


  measure: profit_margin {
    type: number
    sql: ${total_profit}/NULLIF(${total_revenue}, 0) ;;
    value_format_name: percent_2
  }


  measure: average_shipping_time {
    type: average
    sql: ${shipping_time} ;;
    value_format: "0\" days\""
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
}
