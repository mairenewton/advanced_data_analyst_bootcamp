explore: user_facts {}
label: "users"
view: user_facts {
  label: "users"
  derived_table: {
    sql:
      SELECT users.id, COUNT(DISTINCT order_items.order_id)
      FROM order_items JOIN users ON order_items.user_id = users.id
      GROUP BY users.id
      ORDER BY users.id
       ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  measure: average_num_orders {
    type: average
    sql: ${count} ;;
  }

  set: detail {
    fields: [id, count]
  }
}
