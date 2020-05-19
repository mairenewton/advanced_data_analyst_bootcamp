explore: user_state_dt {}

view: user_state_dt {
  derived_table: {
    explore_source: order_items {
      column: total_revenue {}
      column: average_sale_price {}
      column: state { field: users.state }
      derived_column: order_revenue_rank {
        sql:rank() over(order by total_revenue desc) ;;
      }
    } datagroup_trigger: orders
      #persist_for: "4 hours"
      distribution_style: all
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: average_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: state {}
}
