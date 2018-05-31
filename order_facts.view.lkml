view: order_facts {
  derived_table: {
    sql: SELECT
      order_id,
      max(created_at),
      sum(sale_price) as order_value,
      count(*) as item_count
      FROM public.order_items
      GROUP BY 1

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

  dimension_group: max {
    type: time
    sql: ${TABLE}.max ;;
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
    fields: [order_id, max_time, order_value, item_count]
  }
}
