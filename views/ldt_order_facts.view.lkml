view: ldt_order_facts {
  derived_table: {
    sql: SELECT order_id, user_id, COUNT(*) AS ITEM_COUNT
      FROM public.order_items
      GROUP BY 1, 2
       ;;
  }


  dimension: order_id {
    type: number
    primary_key: yes
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

measure: average_items_order {
  type: average
  value_format_name: decimal_2
  sql: ${item_count} ;;
}


}
