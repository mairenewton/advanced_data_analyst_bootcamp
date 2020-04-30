view: user_order_facts {
  derived_table: {
    sql: select
      order_id,
      user_id,
      count(id) as order_item_count,
      sum(sale_price) as order_total
      from public.order_items
      group by order_id, user_id
      order by order_item_count desc
      limit 10;
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

  dimension: order_total {
    type: number
    sql: ${TABLE}.order_total ;;
  }

  set: detail {
    fields: [order_id, user_id, order_item_count, order_total]
  }
}
