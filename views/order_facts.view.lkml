view:order_facts {
  derived_table: {
    sql: SELECT
        order_items.order_id AS order_id
        ,COUNT(*) AS item_count
        ,SUM(order_items.sale_price) AS lifetime_revenue  --we might also be interested in average order total per age group
      FROM order_items
      GROUP BY order_id
      ORDER BY lifetime_revenue DESC
       ;;
  }
measure: average_order_total {
  type: average
  sql: ${average_order_total} ;;
}

  dimension: order_total {
    hidden: yes
    type: number
    sql: ${TABLE}.order_total ;;
    value_format_name: usd
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    value_format_name: usd
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

measure: average_lifetime_order_count {
  type: average
  sql: ${average_lifetime_order_count} ;;
}

measure: average_lifetime_revenue {
  type: average
  sql: ${lifetime_revenue} ;;
  value_format_name: usd
}

  set: detail {
    fields: [order_id, item_count, lifetime_revenue]
  }
}
