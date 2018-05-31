view: users_fact {
  derived_table: {
    sql: SELECT
        a.id as user_id,
        count(distinct b.id) as lifetime_order_count,
        sum(b.sale_price) as lifetime_revenue,
        min(b.created_at) as first_order_date,
        max(b.created_at) as last_order_date
      FROM public.users a
        RIGHT JOIN public.order_items b
          on a.id = b.user_id
      GROUP BY a.id
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

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, last_order_date_time]
  }
}
