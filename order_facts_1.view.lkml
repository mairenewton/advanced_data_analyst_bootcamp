explore: order_facts_1 {}
view: order_facts_1 {
  derived_table: {
    sql: --Average order items per age group
      select oi.order_id,
            oi.user_id,
           count(oi.order_id) as num_orders,
           sum(oi.sale_price) as sale_price
      from public.order_items oi
      group by 1,2
      order by 2 desc
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

  dimension: num_orders {
    type: number
    sql: ${TABLE}.num_orders ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  set: detail {
    fields: [order_id, user_id, num_orders, sale_price]
  }
}
