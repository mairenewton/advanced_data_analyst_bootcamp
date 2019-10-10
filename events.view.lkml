include: "geography_dimensions.view"
include: "system_fields.view"

view: events {
  extends: [geography_dimensions, system_fields]

  sql_table_name: public.events ;;

  # Dimensions

  dimension: user_identifier {
    type: string
    sql: COALESCE(${user_id}::varchar, ${ip_address}) ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # Measures

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
  }

  measure: count_distinct_user_identifiers {
    type: count_distinct
    sql: ${user_identifier} ;;
  }
}
