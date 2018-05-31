# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {}
      column: order_item_count {}
      column: total_revenue {}
    }
    datagroup_trigger: user_facts_datagroup
    sortkeys: ["id"]
    distribution: "id"
  }


  dimension: id {
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
