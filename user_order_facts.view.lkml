# If necessary, uncomment the line below to include explore_source.

include: "advanced_data_analyst_bootcamp.model.lkml"

explore: user_order_facts {}

view: user_order_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: order_items.user_id }
      column: lifetime_number_of_orders { field: order_items.order_count }
      column: lifetime_customer_value { field: order_items.total_revenue }
      derived_column: average_customer_order {
        sql: lifetime_customer_value / lifetime_number_of_orders ;;
      }
    }
  }

  dimension: user_id {
    primary_key: yes
    type: number
  }

  dimension: lifetime_number_of_orders {
    description: "total number of lifetime orders"
    type: number
  }

  dimension: lifetime_customer_value {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: average_customer_order {
    type: number
    value_format_name: usd
  }
}
