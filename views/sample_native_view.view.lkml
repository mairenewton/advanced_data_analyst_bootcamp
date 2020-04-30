# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: add_a_unique_name_1588272338 {
  derived_table: {
    explore_source: order_items {
      column: average_sale_price {}
      column: product_brand { field: inventory_items.product_brand }
      filters: {
        field: order_items.date_range
        value: "7 days"
      }
    }
  }
  dimension: average_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: product_brand {}
}
