view: order_facts {
  derived_table: {
    sql: SELECT
        order_id
        ,MAX(created_at) AS created_at
        ,SUM(sale_price)::DECIMAL(12,2) AS order_value
        ,count(*) AS item_count
      FROM public.order_items
      WHERE {% condition date %} created_at {% endcondition %}
      ELSE 'Other'
      END
      GROUP BY order_id
       ;;
  }

  filter: date {
    type: date
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: created_at {
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
