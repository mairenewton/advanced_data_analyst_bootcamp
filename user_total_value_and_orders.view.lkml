view: user_total_value_and_orders {
  derived_table: {
    sql: select user_id
          ,Sum(sale_price) as total_sales
          ,count(order_id) as order_count
      From order_items
      Group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  set: detail {
    fields: [user_id, total_sales, order_count]
  }

  measure: avg_liftime_value {
    type: average
    sql: ${total_sales} ;;
  }

  measure: avg_liftime_orders {
    type: average
    sql: ${order_count} ;;
  }







}
