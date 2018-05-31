view: user_order_summary {
  derived_table: {
    sql: select
      user_id
      , count(distinct ordre_id)as Lifetime_Order_Count
      , sum(sale_price) as Lifetime_Revenue
      , min(created_at) as First_Order_Date
      , max(created_at) as Latest_Order_Date
      FROM public.order_items
      group by user_id
       ;;
    datagroup_trigger: user_order_summary_datagroup
    sortkeys: ["id"]
    distribution: "id"

  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
