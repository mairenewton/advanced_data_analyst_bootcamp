view: user_facts {
  derived_table: {
    sql: SELECT
        user_id
        ,COUNT(DISTINCT (order_id)) AS lifetime_order_count
        ,SUM(sale_price)::DECIMAL(12,2) AS lifetime_revenue
        ,MIN(created_at) AS first_order_date
        ,MAX(created_at) AS latest_order_date
      FROM order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    timeframes: [
      date
      ,day_of_week
      ,day_of_week_index
      ,day_of_year
      ,hour
      ,hour_of_day
      ,minute
      ,month
      ,month_name
      ,month_num
      ,quarter
      ,quarter_of_year
      ,raw
      ,second
      ,time
      ,time_of_day
      ,week
      ,week_of_year
      ,year
    ]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    timeframes: [
      date
      ,day_of_week
      ,day_of_week_index
      ,day_of_year
      ,hour
      ,hour_of_day
      ,minute
      ,month
      ,month_name
      ,month_num
      ,quarter
      ,quarter_of_year
      ,raw
      ,second
      ,time
      ,time_of_day
      ,week
      ,week_of_year
      ,year
    ]
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
