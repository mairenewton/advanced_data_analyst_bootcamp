view: order_user_facts {
  derived_table: {
    sql: select user_id,
        count (id) as Order_count,
        sum(sale_price) as Lifetime_rev,
        min(created_at) as First_Order,
        max(created_at) as Last_Order
      from order_items
      group by user_id

       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
    value_format_name: decimal_0
  }

  dimension: lifetime_rev {
    type: number
    sql: ${TABLE}.lifetime_rev ;;
    value_format_name: usd
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
  }

  set: detail {
    fields: [user_id, order_count, lifetime_rev, first_order_time, last_order_time]
  }
}
