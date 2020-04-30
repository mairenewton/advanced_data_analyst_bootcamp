view: lifetime_rev_rollup {
  derived_table: {
    sql: select u.state,
      count(distinct o.order_id) as lifetime_order_count,
      sum(o.sale_price) as lifetime_revenue
      from order_items o
      join users u
      on u.id = o.user_id
      group by u.state
      order by u.state;
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [state, lifetime_order_count, lifetime_revenue]
  }
}
