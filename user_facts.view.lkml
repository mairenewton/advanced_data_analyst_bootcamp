view: user_facts {
  derived_table: {
    sql: SELECT
        user_id,
        MAX(created_at) AS last_purch,
        MIN(created_at) AS first_purch,
        SUM(sale_price) AS revenue,
        COUNT(order_id) AS purch_count
      FROM order_items
      GROUP BY user_id
      ;
       ;;
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

  dimension_group: last_purch {
    type: time
    sql: ${TABLE}.last_purch ;;
  }

  dimension_group: first_purch {
    type: time
    sql: ${TABLE}.first_purch ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: purch_count {
    type: number
    sql: ${TABLE}.purch_count ;;
  }

  set: detail {
    fields: [user_id, last_purch_time, first_purch_time, revenue, purch_count]
  }

  measure: Average_LTV{
    type:  average
    sql: ${TABLE}.revenue;;
    value_format_name: usd
  }
}
