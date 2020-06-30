include: "geography.view.lkml"
view: users {
  extends: [geography]
  sql_table_name: public.users ;;

  dimension: id {
#     hidden:  yes
  primary_key: yes
  type: number
  sql: ${TABLE}.id ;;
}

dimension_group: created {
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: ${TABLE}.created_at ;;
}

dimension: age {
  type: number
  value_format_name: decimal_0
  sql: ${TABLE}.age ;;
}

dimension: age_tier {
  type: tier
  style: integer
  sql: ${TABLE}.age ;;
  tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90]
}



dimension: years_a_customer {
  type: number
  value_format_name: decimal_0
  sql: DATEDIFF(year, ${created_date}, current_date) ;;
}

dimension: gender {
  type: string
  sql: ${TABLE}.gender ;;
}

dimension: traffic_source {
  type: string
  sql: ${TABLE}.traffic_source ;;
}


measure: max_age {
  type: max
  sql: ${age} ;;
}

measure: average_age {
  type: average
  sql: ${age} ;;
}

measure: count {
  type: count
  drill_fields: [id, events.count, order_items.count]
}

dimension: email {
  type: string
  sql: ${TABLE}.email ;;
}

dimension: first_name {
  hidden:  yes
  type: string
  sql: ${TABLE}.first_name ;;
}

dimension: last_name {
  hidden:  yes
  type: string
  sql: ${TABLE}.last_name ;;
}

dimension: name {
  type: string
  sql: ${first_name} || ' ' || ${last_name} ;;
}
}
