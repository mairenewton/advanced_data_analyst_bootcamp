view: order_facts_1 {
  derived_table: {
    sql: SELECT
        user_id,
        COUNT(DISTINCT order_id) as lifetime_order_count,
        SUM(sale_price) as lifetime_revenue,
        MIN(created_at) as first_order_date,
        MAX(created_at) as last_order_date
      FROM public.order_items
      GROUP BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      month_name,
      year
    ]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      month_name,
      year
    ]
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [user_id, order_count, lifetime_revenue, first_order_date_date, last_order_date_date]
  }
}
