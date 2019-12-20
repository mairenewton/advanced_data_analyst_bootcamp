include: "geography_View.view"
view: events {
  extends: [geography_dim]
  sql_table_name: public.events ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_identifier {
    type: string
    sql: COALESCE(${user_id}::varchar, ${ip_address}) ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

#Geography {

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

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }



  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
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



  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
  }

  measure: count_distinct_user_identifiers {
    type: count_distinct
    sql: ${user_identifier} ;;
  }
}
