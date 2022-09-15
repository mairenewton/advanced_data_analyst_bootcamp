connection: "events_ecommerce"
persist_with: default

# include all the views
include: "/views/*.view"

# include all the dashboards
#include: "*.dashboard"

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

explore:  orderdetails {}

explore: order_items {
# fields: [ALL_FIELDS* , -users.days_since_first_order,-users.days_since_last_order]
  join: users {
    fields: [user_fields_for_order_items*]
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  # join: user_order_facts {
  #   type: left_outer
  #   sql_on: ${order_items.user_id}  = ${user_order_facts.user_id} ;;
  #   relationship: many_to_one
  # }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
  }
  join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_order_facts {
    type: left_outer
    sql_on: ${events.user_id}  = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
# explore: user_order_facts {}
explore: users {
  label: "Users, Orders, and Inventory"

  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }
  # join: users_extends {
  #   type: left_outer
  #   sql_on: ${users.id} = ${users_extends.id} ;;
  #   relationship: one_to_one
  # }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }


}
