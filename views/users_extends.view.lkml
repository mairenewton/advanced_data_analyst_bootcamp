# include: "users.view"
# view: users_extends {
# view_label: "users"
# extends: [users]
#   dimension: days_since_first_order {
#     description: "Days between first order and current date"
#     type: number
#     sql: DATEDIFF(day,${user_order_facts.first_order_date},current_date) ;;
#   }
#   dimension: days_since_last_order {
#     description: "Days between first order and current date"
#     type: number
#     sql: DATEDIFF(day,${user_order_facts.latest_order_date},current_date) ;;
#   }
# }
