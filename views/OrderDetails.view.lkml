view: orderdetails
# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

 {
  derived_table: {
    explore_source: order_items {
      column: order_item_count {}
      column: average_sale_price {}
      column: order_id {}
    }
  }
  dimension: order_item_count {
    type: number
  }
  dimension: average_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    primary_key: yes

    type: number
  }
}
