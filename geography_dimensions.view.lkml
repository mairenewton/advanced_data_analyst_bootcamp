# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: geography_dimensions {
  extension: required

##Geography {
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }
#}
}
