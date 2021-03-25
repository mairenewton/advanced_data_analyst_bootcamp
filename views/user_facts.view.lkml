view: user_facts {
  derived_table: {
    sql:
      SELECT user_id,
        COUNT(DISTINCT order_id) AS lifetime_order_count,
        SUM(sale_price) AS lifetime_value
      FROM order_items
      GROUP BY 1
       ;;
  }

  dimension: user_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    hidden: yes
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_value {
    hidden: yes
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  measure: average_lifetime_value {
    type: average
    value_format_name: usd
    sql: ${lifetime_value} ;;
  }

  measure: average_lifetime_order_count {
    type: average
    sql: ${lifetime_order_count} ;;
  }
}
