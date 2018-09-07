# include: "order_items.view"
#
# view: order_items_with_references {
#   extends: [order_items]
#
#   measure: average_spend_per_user {
#     type: number
#     value_format_name: usd
#     sql: 1.0 * ${total_revenue} / NULLIF(${users.count},0) ;;
#   }
#
#   dimension: profit {
#     description: "Profit made on any one item"
#     hidden:  yes
#     type: number
#     value_format_name: usd
#     sql: ${sale_price} - ${inventory_items.cost} ;;
#   }
#
#   measure: total_profit {
#     type: sum
#     sql: ${profit} ;;
#     value_format_name: usd
#   }
#
#
#   measure: profit_margin {
#     type: number
#     sql: ${total_profit}/NULLIF(${total_revenue}, 0) ;;
#     value_format_name: percent_2
#   }
#
# }
