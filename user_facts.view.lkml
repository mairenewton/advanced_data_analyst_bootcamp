view: user_facts {
  derived_table: {
    sql: select user_id,
      sum(sale_price) as life_time_spend,
      avg(sale_price) as avg_spend
      from public.order_items
      group by user_id
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

  dimension: life_time_spend {
    type: number
    sql: ${TABLE}.life_time_spend ;;
  }
  measure: average_lifetime_spend {
    type: average
    sql: ${life_time_spend} ;;
  }
  dimension: avg_spend {
    type: number
    sql: ${TABLE}.avg_spend ;;
  }

  set: detail {
    fields: [user_id, life_time_spend, avg_spend]
  }
}
