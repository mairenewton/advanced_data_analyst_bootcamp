view: exercise_1 {
  derived_table: {
    sql: SELECT
      user_id,
      sum(sale_price) as lifetime_value,
      count(distinct order_id) as lifetime_order_count
      FROM public.order_items
      Group by user_id
       ;;
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [user_id, lifetime_value, lifetime_order_count]
  }
}
