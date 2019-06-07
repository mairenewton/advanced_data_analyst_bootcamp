view: users_fact {
  derived_table: {
    sql: select users.state, users.id, count(order_items.id), sum(order_items.sale_price), min(order_items.created_at), max(order_items.created_at) from users
      join order_items on users.id = order_items.user_id
      group by 1,2
       ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: sum {
    type: number
    sql: ${TABLE}.sum ;;
  }

  dimension_group: min {
    type: time
    sql: ${TABLE}.min ;;
  }

  dimension_group: max {
    type: time
    sql: ${TABLE}.max ;;
  }

  set: detail {
    fields: [
      state,
      id,
      count,
      sum,
      min_time,
      max_time
    ]
  }
}
