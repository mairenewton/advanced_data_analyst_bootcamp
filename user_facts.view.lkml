view: user_facts {
  derived_table: {
    sql: SELECT
      user_id,
      count(order_id) as lifetime_order_count,
      min(created_at) as first_order,
      max(created_at) as latest_order,
      sum(sale_price) as lifetime_revenue
      FROM public.order_items
      Group by user_id

      LIMIT 10
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

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  set: detail {
    fields: [user_id, first_order_time, latest_order_time, lifetime_revenue, lifetime_order_count]
  }
}
