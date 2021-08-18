view: user_facts {
  derived_table: {
    sql: SELECT
         order_items.user_id AS user_id
         ,users.state AS state
        ,COUNT(distinct order_items.order_id) AS lifetime_order_count
        ,SUM(order_items.sale_price) AS lifetime_revenue
        ,MIN(order_items.created_at) AS first_order_date
        ,MAX(order_items.created_at) AS latest_order_date
      FROM order_items
      JOIN users on order_items.user_id = users.id
      WHERE
      {% condition date_filter %}
      order_items.created_at
      {% endcondition %}
      GROUP BY user_id, state
       ;;
  }
  filter: date_filter { datatype: date
    }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: pk {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${user_id} || ${state} ;;
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  measure: average_order_count {
    type: average
    sql: ${lifetime_order_count} ;;
  }


  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
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
    fields: [
      user_id,
      state,
      lifetime_order_count,
      lifetime_revenue,
      first_order_date_time,
      latest_order_date_time
    ]
  }
}
