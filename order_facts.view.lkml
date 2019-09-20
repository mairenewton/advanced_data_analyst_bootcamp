view: order_facts{
  derived_table: {
    sql: SELECT
    order_id
    , user_id
    , count(*) as order_item_count
    , sum(sale_price) as total_sales
    FROM public.order_items
    group by order_id, user_id
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_item_count {
    type: number
    sql: ${TABLE}.order_item_count ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  set: detail {
    fields: [order_id, user_id, order_item_count, total_sales]
  }
}
