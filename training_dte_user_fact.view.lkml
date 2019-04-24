view: training_dte_user_fact {
  derived_table: {
    sql: select
      user_id AS user_id,
      COUNT(distinct order_id) AS lifetime_order_count,
      SUM(sale_price) AS lifetime_revenue,
      MIN(created_at) AS first_order_date,
      MAX(created_at) AS latest_order_date
      FROM
      order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
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
  measure: average_lifetime_value {
    type: average
    sql:${lifetime_revenue}  ;;

  }
}
