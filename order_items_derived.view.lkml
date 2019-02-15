view: derived_tables {
  derived_table: {
    sql: SELECT order_id, count(*) FROM public.order_items  group by order_id
      ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }
measure: average_order_item{
  type: average
  sql: ${count} ;;
}
  set: detail {
    fields: [order_id, count]
  }
}
