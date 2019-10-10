include: "geography_dimensions.view"
include: "system_fields.view"

view: users {
  extends: [geography_dimensions, system_fields]

  sql_table_name: public.users ;;

  # Dimensions

  dimension: id {
    # hidden:  yes
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

  dimension: map_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: email {
    type: string
    required_access_grants: [is_pii_viewer]
    sql: ${TABLE}.email ;;
    link: {
      label: "Category Detail Dashboard"
      url: "/dashboards/1813?Email={{value}}"
    }
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
    link: {
      label: "Drill Down to See Customers"
      url: "/explore/advanced_data_analyst_bootcamp/users?fields=users.id,users.name,users.email,order_items.order_count&f[users.state]={{ _filters['users.state'] | url_encode }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  # Measures

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
}
