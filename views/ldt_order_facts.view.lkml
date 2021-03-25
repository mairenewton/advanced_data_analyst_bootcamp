view: ldt_order_facts {
  derived_table: {
    sql: select
        order_id,
        user_id,
        count(*) as item_count
      from public.order_items
      group by 1,2
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

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  measure: average_items_ordered {
    type: average
    sql: ${item_count} ;;
  }

}
