view: user_facts {
  derived_table: {
    sql: SELECT
      user_id,
      count(distinct order_id) as order_count,
      sum(sale_price) as lifetime_value,
      max(created_at) as latest_order_date,
      min(created_at) as first_order_date
      FROM public.order_items
      GROUP by 1

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

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  set: detail {
    fields: [user_id, order_count, lifetime_value, latest_order_date_time, first_order_date_time]
  }
}
