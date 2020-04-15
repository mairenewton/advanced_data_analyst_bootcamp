view: order_facts {
  derived_table: {
    distribution: "order_id"
    sortkeys: ["order_id"]
    datagroup_trigger: default

    sql: SELECT
      order_id,
      sum(sale_price) as total_order_value,
      count(*) as item_count
      FROM public.order_items
      group by 1
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

  dimension: total_order_value {
    type: number
    sql: ${TABLE}.total_order_value ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  set: detail {
    fields: [order_id, total_order_value, item_count]
  }
}
