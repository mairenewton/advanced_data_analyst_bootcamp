explore: user_order_fact {}

view: user_order_fact {
  derived_table: {
    distribution: "user_id"
    sortkeys: ["user_id"]
    sql: SELECT user_id,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(sale_price) AS total_rev,
        MIN(created_at) AS first_order_date,
        MAX(created_at) AS last_order_date
FROM order_items
GROUP BY 1
 ;;

sql_trigger_value: select current_date ;;
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

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: total_rev {
    type: number
    sql: ${TABLE}.total_rev ;;
  }

  dimension_group: first_order_date {
    timeframes: [
      date,
      month,
      quarter,
      year
    ]
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    timeframes: [
      date,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [user_id, order_count, total_rev]
  }
}
