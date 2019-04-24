# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

  view: item_avg_order_by_state {
  derived_table: {
    explore_source: users {
      column: order_id { field: order_items.order_id }
      column: order_item_count { field: order_items.order_item_count }
      column: average_sale_price { field: order_items.average_sale_price }
      column: state {}
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: average_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: state {}
}
