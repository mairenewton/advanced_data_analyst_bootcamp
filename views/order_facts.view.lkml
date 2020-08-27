view: order_facts {
  derived_table: {
    sql: select
          order_id,
          user_id,
          count(*) as order_item_count,
          sum(sale_price) as order_total
          from  public.order_items
          group by 1,2;;
  }

  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_item_count {
    hidden: yes
    type: number
    sql: ${TABLE}.order_item_count ;;
  }

  dimension: order_total {
    hidden: yes
    type: number
    sql: ${TABLE}.order_total ;;
  }

  measure: average_number_of_order_items {
    type: average
    sql:  ${order_item_count} ;;
    drill_fields: [detail*]
    value_format_name: decimal_2
  }

  set: detail {
    fields: [order_id, user_id, order_item_count, order_total]
  }
}
