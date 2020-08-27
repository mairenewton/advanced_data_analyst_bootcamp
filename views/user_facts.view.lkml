view: user_facts {
  derived_table: {
    sql:
      select  user_id,
              sum(sale_price) as lifetime_value,
              count(distinct order_id) as lifetime_order_count
      from    public.order_items
      group by 1;;
  }

  dimension: user_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_value {
    hidden: yes
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  dimension: lifetime_order_count {
    hidden: yes
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  measure: average_lifetime_value {
    type: average
    sql:  ${lifetime_value} ;;
    value_format_name: usd_0
    drill_fields: [detail*]
  }

  measure: average_lifetime_order_count {
    type: average
    sql:  ${lifetime_order_count} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  set: detail {
    fields: [user_id, lifetime_value, lifetime_order_count]
  }
}
