view: user_facts {
  derived_table: {
    sql: select o1.user_id ,
      count(distinct o1.order_id) as lifetime_order_count,
      sum(o1.sale_price) as lifetime_revenue

      from order_items o1
      group by o1.user_id
       ;;
  }

#  measure: count {
 #   type: count
#    drill_fields: [detail*]
 # }

  dimension: user_id {
    primary_key: yes
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

  measure: average_lifetime_value {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_order_count} ;;
    #value_format_name: usd
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
