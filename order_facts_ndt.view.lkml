
view: order_facts_ndt {
  derived_table: {
    explore_source: users {
      column: order_id { field: order_items.order_id }
      column: order_item_count { field: order_items.order_item_count }
      column: total_revenue { field: order_items.total_revenue }
      filters: {
        field: users.country
        value: "USA"
      }
    }
  }
  dimension: order_id {
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
