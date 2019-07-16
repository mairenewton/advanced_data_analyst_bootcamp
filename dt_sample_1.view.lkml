view: dt_sample_1 {
  derived_table: {
    sql: SELECT
        COUNT(DISTINCT users.id ) AS "users.count"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id
       ;;
  }


  dimension: users_count {
    type: number
    sql: ${TABLE}."users.count" ;;
  }

  set: detail {
    fields: [users_count]
  }
}
