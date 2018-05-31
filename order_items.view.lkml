view: order_items {
  sql_table_name: public.order_items ;;

  parameter: select_timeframe {
    label: "Choose a timeframe"
    description:  "Select a timeframe for viewimng the data"
    type: string
    default_value: "year"
    allowed_value: {
      label: "Year"
      value: "year"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Week (num)"
      value: "week_w"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Month Name"
      value: "month_name"
    }
  }

  dimension: dynamic_timeframe{
    description: "Timeframe"
    label_from_parameter: select_timeframe
    type: string
    sql: CASE
      WHEN {% parameter select_timeframe %} = 'month' THEN ${created_month}
      WHEN {% parameter select_timeframe %} = 'week' THEN ${created_week}
      WHEN {% parameter select_timeframe %} = 'week_w' THEN ${week_w}
      WHEN {% parameter select_timeframe %} = 'month_name' THEN ${created_month_name}
      ELSE TO_CHAR(${created_year},'9999')
      END
    ;;
  }

  filter: select_order_id {
    type:  string
    suggest_dimension: order_id

  }

  dimension: similar_order_id {
    type:  string
    sql: CASE
      WHEN {% condition select_order_id %} ${order_id} {% endcondition %} THEN ${order_id}
      ELSE NULL
      END
      ;;
  }

  parameter: select_measure {
    label: "Choose a measure"
    description:  "Select a measure"
    type: string
    default_value: "year"
    allowed_value: {
      label: "Total Revenue"
      value: "total revenue"
    }
    allowed_value: {
      label: "Order Count"
      value: "order count"
    }
    allowed_value: {
      label: "Average Sale Price"
      value: "average sale price"
    }
  }

  measure: dynamic_measure{
    description: "Measure"
    label_from_parameter: select_measure
    type: number
    sql: CASE
      WHEN {% parameter select_measure %} = 'total revenue' THEN ${total_revenue}::DECIMAL(12,2)
      WHEN {% parameter select_measure %} = 'order count' THEN ${order_count}::INT
      WHEN {% parameter select_measure %} = 'average sale price' THEN ${average_sale_price}::DECIMAL(12,2)
      ELSE ${total_revenue}
      END
    ;;
  }

  dimension: week_w {
    group_label: "Created Date"
    hidden:  no
    primary_key: no
    type: string
    sql: 'W_'||(EXTRACT('week' FROM ${created_date}))::VARCHAR(24) ;;
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
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
