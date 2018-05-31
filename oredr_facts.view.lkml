view: order_facts {
  derived_table: {
    sql: SELECT
      order_id,
      max(created_at) as created_at,
      sum(sale_price) as order_value,
      count(*) as item_count
      from public.order_items
      WHERE {% condition date %} created_at {% endcondition %}
      GROUP BY 1

      LIMIT 10
       ;;

  datagroup_trigger: order_fact_datagroup
  sortkeys: ["order_id"]
  distribution: "order_id"
  }

# a date place holder
filter: date {
  type: date
}



  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
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
