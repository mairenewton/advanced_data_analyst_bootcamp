view: order_facts {
  derived_table: {
    sql: select user_id, sum(sale_price) as lifetime_spend, count(id) as lifetime_items_ordered
      from order_items
      group by user_id
       ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_spend {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
  }

  dimension: lifetime_items_ordered {
    type: number
    sql: ${TABLE}.lifetime_items_ordered ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_lifetime_spend {
    type: average
    sql: ${lifetime_spend} ;;
    value_format_name: decimal_2
  }

  measure: average_lifetime_items_ordered {
    type: average
    sql: ${lifetime_items_ordered} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [user_id, lifetime_spend, lifetime_items_ordered]
  }
}
