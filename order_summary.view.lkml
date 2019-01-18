#explore: order_summary {}
view: order_summary {
  derived_table: {
    sql: select order_id,
      count(*) as count_of_order_items,
      min(created_at) as first_order_date,
      max(created_at) as last_order_date
      FROM public.order_items
      GROUP BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: count_of_order_items {
    type: number
    sql: ${TABLE}.count_of_order_items ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [order_id, count_of_order_items, first_order_date_time, last_order_date_time]
  }
}
