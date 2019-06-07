include: "advanced_data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_item_count {}
      column: total_revenue {}
      column: order_id {}
    }
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    type: number
  }
}
