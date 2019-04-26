include: "explores"
view: users_summary_ndt {
#   derived_table: {
#     explore_source: users {
#       column: user_id {field:users.id}
#       column: lifetime_order_item_count {field:order_items.order_item_count}
#
#       bind_filters: {
#         to_field: users.id
#         from_field: users_summary_ndt.user_id
#       }
#     }
#   }
#   dimension: user_id {}
#   dimension: lifetime_order_item_count {}
#   measure: avg_lifetime_order_item_count {
#     type: average
#     sql: ${lifetime_order_item_count} ;;
#   }

# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"



#   view: add_a_unique_name_1555900541 {
  derived_table: {
    explore_source: users {
      column: age {}
      column: age_tier {}
      column: city {}
      column: country {}
#       column: created_date {}
      column: email {}
      column: gender {}

      column: map_location {}
      column: name {}
      column: region {}
      column: state {}
      column: traffic_source {}
      column: years_a_customer {}
      column: zip {}



      column: user_id {field:users.id}
      column: count_users {field:users.count}
      column: average_age_users {field:users.average_age}

      column: lifetime_order_items_count {field:order_items.order_item_count}
    }
  }
  dimension: age {
#     value_format: "#,##0"
    type: number
  }
#   dimension: age_tier {
#     type: tier
#   }
  dimension: city {}
  dimension: country {}
#   dimension: created_date {
#     type: date
#   }
  dimension: email {}
  dimension: gender {}

#   dimension: map_location {
#     type: location
#   }
  dimension: name {}
  dimension: region {}
  dimension: state {}
  dimension: traffic_source {}
  dimension: years_a_customer {
#     value_format: "#,##0"
    type: number
  }
  dimension: zip {
    type: zipcode
  }



  dimension: user_id {
    type: number
  }

  dimension: count_users {
    type: number
  }

  dimension: average_age_users {
    type: number
  }

  dimension: lifetime_order_items_count {
    type: number
  }

}
