view: order_items {
  sql_table_name: public.order_items ;;

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

# dimension: date_filter_measure {
#   hidden: yes
#   type: yesno
#   sql: {% condition date_range %} ${order_items.created_date} {% endcondition %} ;;
# }

# dimension: date_filter_measure_one_year_prior {
#   hidden: yes
#   type: yesno
#   sql: {% condition date_range %} ${order_items.created_date} {% endcondition %} ;;
# }

## MEASURES ##

measure: order_item_count {
  type: count
  drill_fields: [detail*]
}

measure: total_revenue {
  type: sum
  value_format_name: usd
  sql: ${sale_price} ;;
  html:
  <div style width="100%"> <details>
  <summary style="outline:none">{{ rendered_value }}
  </summary> Total Cost: {{ inventory_items.total_cost._linked_value }}
  </details>
  </div> ;;
}



measure: average_sale_price {
  type: average
  value_format_name: usd
  sql: ${sale_price} ;;
  drill_fields: [detail*]
}

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Email"]
    value_format_name: usd_0

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
