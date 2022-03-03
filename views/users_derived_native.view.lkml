view: users_native {
  derived_table: {
    explore_source: users {
      column: order_id { field: order_items.order_id }
      column: order_item_count { field: order_items.order_item_count }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: order_item_count {
    type: number
  }
}
