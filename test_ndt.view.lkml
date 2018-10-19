
view: Test_NDT {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: order_count {}
      column: total_revenue {}
      derived_column: order_revenue_rank{
        sql: rank () over (partition by order_id order by total_revenue  desc) ;;
      }
    }
  }
  dimension: order_id {
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
  dimension: order_revenue_rank{
    type: number
    value_format_name: decimal_0
  }
}
