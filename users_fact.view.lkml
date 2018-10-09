view: users_fact {
  derived_table: {
    sql: select  a.id as user_id,
        count(distinct b.order_id) as lifetime_orders,
        sum(b.sale_price) as lifetime_revenue,
        min(b.created_at) as first_orderdate,
        max(b.created_at) as last_orderdate
from users as a
join order_items as b on a.id = b.user_id
group by 1
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

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      date,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_orderdate ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      date
    ]
    sql: ${TABLE}.last_orderdate ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue, first_order_raw, last_order_raw]
  }
}
