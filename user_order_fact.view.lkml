view: user_order_fact {
  derived_table: {
    sql: SELECT
        users.id,
        COUNT(order_items.order_id) lifetime_order_count,
        SUM(order_items.sale_price) lifetime_revenue,
        MIN(order_items.created_at) first_order,
        MAX(order_items.created_at) last_order
      FROM users
      LEFT JOIN order_items
      ON users.id = order_items.user_id
      WHERE {% condition choose_state %} users.state {% endcondition %}
      GROUP BY 1
      LIMIT 10
       ;;
      datagroup_trigger: etl_order_items
      distribution: "user_id"
      sortkeys: ["user_id"]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: choose_state {
    type: string
    suggest_explore: users
    suggest_dimension: users.state
  }


  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [time,date,week,month,year]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [time,date,week,month,year]
    sql: ${TABLE}.last_order ;;
  }

#   dimension: last_order_month_name_month_number {
#     label: "Month Day Number"
#     group_label: ""
#     sql:  ;;
#   }


  set: detail {
    fields: [id, lifetime_order_count, lifetime_revenue, first_order_date, last_order_date]
  }
}
