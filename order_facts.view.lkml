view: order_facts {
  derived_table: {
    sql: SELECT
      ORDER_ID,
      max(created_at) as created_at,
      sum(sale_price) as order_value,
      count(*) as item_count
      FROM public.order_items
      Group by 1

      LIMIT 10
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: order_value {
    type: number
    sql: ${TABLE}.order_value ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  set: detail {
    fields: [order_id, created_at_time, order_value, item_count]
  }
}
