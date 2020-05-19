# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: User_State_dt {
  derived_table: {
    explore_source: order_items {
      column: total_revenue {}
      column: average_sale_price {}
      column: state { field: users.state }
    }
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
