include: "geography.view"

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

  dimension: city_state{
    type: string
    sql: concat(${city}, concat( ', ', ${state})) ;;
    description: "Dimension Type Practice"
  }
#}

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

dimension: region {
#     map_layer_name: map_regions
sql: CASE WHEN ${state} = 'Maine' THEN 'Northeast'
              WHEN ${state} = 'Massachusetts' THEN 'Northeast'
              WHEN ${state} = 'Rhode Island' THEN 'Northeast'
              WHEN ${state} = 'Connecticut' THEN 'Northeast'
              WHEN ${state} = 'New Hampshire' THEN 'Northeast'
              WHEN ${state} = 'Vermont' THEN 'Northeast'
              WHEN ${state} = 'New York' THEN 'Northeast'
              WHEN ${state} = 'Pennsylvania' THEN 'Northeast'
              WHEN ${state} = 'New Jersey' THEN 'Northeast'
              WHEN ${state} = 'Delaware' THEN 'Northeast'
              WHEN ${state} = 'Maryland' THEN 'Northeast'
              WHEN ${state} = 'West Virginia' THEN 'Southeast'
              WHEN ${state} = 'Virginia' THEN 'Southeast'
              WHEN ${state} = 'Kentucky' THEN 'Southeast'
              WHEN ${state} = 'Tennessee' THEN 'Southeast'
              WHEN ${state} = 'North Carolina' THEN 'Southeast'
              WHEN ${state} = 'South Carolina' THEN 'Southeast'
              WHEN ${state} = 'Georgia' THEN 'Southeast'
              WHEN ${state} = 'Alabama' THEN 'Southeast'
              WHEN ${state} = 'Mississippi' THEN 'Southeast'
              WHEN ${state} = 'Arkansas' THEN 'Southeast'
              WHEN ${state} = 'Louisiana' THEN 'Southeast'
              WHEN ${state} = 'Florida' THEN 'Southeast'
              WHEN ${state} = 'Ohio' THEN 'Midwest'
              WHEN ${state} = 'Indiana' THEN 'Midwest'
              WHEN ${state} = 'Michigan' THEN 'Midwest'
              WHEN ${state} = 'Illinois' THEN 'Midwest'
              WHEN ${state} = 'Missouri' THEN 'Midwest'
              WHEN ${state} = 'Wisconsin' THEN 'Midwest'
              WHEN ${state} = 'Minnesota' THEN 'Midwest'
              WHEN ${state} = 'Iowa' THEN 'Midwest'
              WHEN ${state} = 'Kansas' THEN 'Midwest'
              WHEN ${state} = 'Nebraska' THEN 'Midwest'
              WHEN ${state} = 'South Dakota' THEN 'Midwest'
              WHEN ${state} = 'North Dakota' THEN 'Midwest'
              WHEN ${state} = 'Texas' THEN 'Southwest'
              WHEN ${state} = 'Oklahoma' THEN 'Southwest'
              WHEN ${state} = 'New Mexico' THEN 'Southwest'
              WHEN ${state} = 'Arizona' THEN 'Southwest'
              WHEN ${state} = 'Colorado' THEN 'West'
              WHEN ${state} = 'Wyoming' THEN 'West'
              WHEN ${state} = 'Montana' THEN 'West'
              WHEN ${state} = 'Idaho' THEN 'West'
              WHEN ${state} = 'Washington' THEN 'West'
              WHEN ${state} = 'Oregon' THEN 'West'
              WHEN ${state} = 'Utah' THEN 'West'
              WHEN ${state} = 'Nevada' THEN 'West'
              WHEN ${state} = 'California' THEN 'West'
              WHEN ${state} = 'Alaska' THEN 'West'
              WHEN ${state} = 'Hawaii' THEN 'West'
              ELSE 'Outside US'
          END ;;
}

dimension: map_location {
  type: location
  sql_latitude: ${latitude} ;;
  sql_longitude: ${longitude} ;;
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
  link: {
    label: "eCommerce Sample User Dashboard"
    url: "/dashboards/1813?Email= {{ value }}"
    icon_url: "https://cdn1.vectorstock.com/i/1000x1000/83/80/unicorn-icon-isolated-on-white-background-vector-21578380.jpg"
  }
  required_access_grants: [pii_access]
}

dimension: first_name {
  hidden:  yes
  type: string
  sql: ${TABLE}.first_name ;;
  required_access_grants: [pii_access]
}

dimension: last_name {
  hidden:  yes
  type: string
  sql: ${TABLE}.last_name ;;
  required_access_grants: [pii_access]
}

dimension: name {
  type: string
  sql: ${first_name} || ' ' || ${last_name} ;;
  required_access_grants: [pii_access]
}

#parameter: traffic_source_par {
#  type: unquoted
#  default_value: "Display"
#  allowed_value: {
#    value: "Display"
#    label: "Display"
#    }
#  allowed_value: {
#    value: "Email"
#    label: "Email"
#    {
#  allowed_value: {
#    value: "Facebook"
#    label: "Facebook"
#    }
#  allowed_value: {
#    value: "Organic"
#    label: "Organic"
#    }
#  allowed_value: {
#    value: "Search"
#    label: "Search"
#  }
#}
#}

filter: traffic_source_par {
  type: string
  suggest_explore: users
  suggest_dimension: users.traffic_source
}

dimension: traffic_source_par_hidden {
  type: yesno
  hidden: yes
  sql: {% condition traffic_source_par %} ${traffic_source} {% endcondition %};;
}

  measure: user_traffic_source_count {
    type: count
    filters: {
      field: users.traffic_source_par_hidden
      value: "Yes"
    }
  }

}
