view: user_facts {
  derived_table: {
    sql: select user_id
        , count(order_id) as lifetime_orders
        , sum(sale_price) as lifetime_revenue
        , min(created_at) as first_order_date
        , max(created_at) as latest_order_date
      from order_items
      group by user_id
       ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
