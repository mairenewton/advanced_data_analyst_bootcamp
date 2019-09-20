view: order_facts{
  derived_table: {
    sql: SELECT
    order_id
    , user_id
    , count(*) as item_count
    , sum(sale_price) as total_order_value
    FROM public.order_items
    group by order_id, user_id;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: total_order_value {
    type: number
    sql: ${TABLE}.total_order_value ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_number_of_order_items{
    type: average
    sql: ${item_count};;
    group_label: "New Metrics"
    description: "For all customers that had orders, average the number of items in their cart"
  }

  set: detail {
    fields: [order_id, user_id, item_count, total_order_value]
  }
}
