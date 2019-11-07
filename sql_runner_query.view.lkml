view: sql_runner_query {
  derived_table: {
    sql: SELECT
          order_id
          ,user_id
          ,count(id) as order_item_count
          ,SUM(sale_price) as order_total_sales
      FROM order_items
      GROUP BY order_id,user_id
      ORDER BY order_item_count DESC
      limit 10
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

  dimension: order_total_sales {
    type: number
    sql: ${TABLE}.order_total_sales ;;
  }

  set: detail {
    fields: [order_id, user_id, order_item_count, order_total_sales]
  }
}
