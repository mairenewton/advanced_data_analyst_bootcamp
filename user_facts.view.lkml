view: user_facts {
  derived_table: {
    sql: SELECT
      user_id,
      count(distinct order_id) as order,
      sum(sale_price) as lifetime_value,
      min(created_at) as first_order_date,
      max(created_at) as lastest_order_date
      FROM public.order_items as orders

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

  dimension: order {
    type: number
    sql: ${TABLE}."order" ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: lastest_order_date {
    type: time
    sql: ${TABLE}.lastest_order_date ;;
  }

  set: detail {
    fields: [user_id, order, lifetime_value, first_order_date_time, lastest_order_date_time]
  }
}
