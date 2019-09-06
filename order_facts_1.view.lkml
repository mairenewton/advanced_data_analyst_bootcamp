view: order_facts_1 {
  derived_table: {
    sql: select order_id, user_id, count(*) as item_count, sum(sale_price) as sale_price
    from order_items
    group by 1,2
    order by 3 desc
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

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  set: detail {
    fields: [order_id, user_id, item_count, sale_price]
  }
}
