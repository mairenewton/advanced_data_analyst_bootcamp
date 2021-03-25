view: ldt_order_facts {
  derived_table: {
    sql: SELECT order_id, user_id, COUNT(*) AS item_count
      FROM order_items
      GROUP BY 1,2
       ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  measure: average_item_count {
    type: average
    sql: ${item_count} ;;
  }

  set: detail {
    fields: [order_id, user_id, average_item_count]
  }
}
