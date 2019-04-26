include: "users.view"
include: "order_items.view"
include: "inventory_items.view"
include: "users_summary_ndt.view"

explore: users {
  from: users
  view_name: users
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
  join: users_summary_ndt {
    relationship: one_to_one
    type: left_outer
    sql_on: ${users.id}=${users_summary_ndt.user_id} ;;
  }
}

include: "users_summary_ndt.view"
explore: users_summary_ndt {
}

view: users_combined {extends: [users,users_summary_ndt]}

explore: users_combined {
  view_name: users
  from: users_combined
#   join: users_summary_ndt {
#     relationship: one_to_one
#     type: left_outer
#     sql_on: ${users.id}=${users_summary_ndt.user_id} ;;
#   }

}
