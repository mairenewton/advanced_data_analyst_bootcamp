# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_order_fact_ndt {
  derived_table: {
    explore_source: users {
      column: id {}
      column: total_revenue { field: order_items.total_revenue }
      column: total_profit { field: order_items.total_profit }
      column: order_count { field: order_items.order_count }
      filters: {
        field: order_items.created_date
        value: "12 months"
      }
    }
  }
  dimension: id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: total_profit {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
}
