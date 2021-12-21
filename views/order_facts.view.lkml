view: order_facts {
  derived_table: {
    sql: SELECT order_id,
      user_id,
      count(*) as order_item_fact,
      sum(sale_price) as order_total
      FROM public.order_items
      GROUP BY 1, 2
       ;;
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_item_fact {
    type: number
    sql: ${TABLE}.order_item_fact ;;
  }

  dimension: order_total {
    hidden: yes
    type: number
    sql: ${TABLE}.order_total ;;
    value_format_name: usd
  }

  measure: average_order_total {
    type: average
    sql: ${order_total} ;;
    value_format_name: usd
  }

  set: detail {
    fields: [order_id, user_id, order_item_fact, order_total]
  }
}
