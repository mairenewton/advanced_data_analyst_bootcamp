view: items_per_order {
  derived_table: {
    sql: Select order_id
          ,Count(*) as count_of_items
      from order_items
      group by Order_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key:  yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: count_of_items {
    type: number
    sql: ${TABLE}.count_of_items ;;
  }

  set: detail {
    fields: [order_id, count_of_items]
  }

  measure: average_items_per_order {
    type: average
    sql: ${count_of_items} ;;
  }
}
