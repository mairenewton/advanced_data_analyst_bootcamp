view: user_facts {
  derived_table: {
    sql: SELECT
        user_id,
        SUM(sale_price) as lifetime_sales,
        COUNT(*) as lifetime_order_item,
        COUNT(DISTINCT order_id) as limetime_orders,
        MIN(created_at) as first_order,
        MAX(created_at) as last_order
      FROM public.order_items
      GROUP BY 1;;
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  dimension: lifetime_order_item {
    type: number
    sql: ${TABLE}.lifetime_order_item ;;
  }

  dimension: limetime_orders {
    type: number
    sql: ${TABLE}.limetime_orders ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [raw,date]
    sql: ${TABLE}.last_order ;;
  }

}
