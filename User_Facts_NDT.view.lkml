
view: User_Facts_NDT {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {field:order_items.order_count}
      column: total_revenue {}
      column: average_shipping_time {}
      derived_column: order_sequence {
        sql: rank () over (partition by user_id order by order_id asc) ;;
      }
    }
  }
  filter: total_revenue_filter {
    label: "Total Revenue Filter"
    type: number
  }

  dimension: id {
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number

  }
  dimension: average_shipping_time {
    value_format: "0 days"
    type: number
  }
}
