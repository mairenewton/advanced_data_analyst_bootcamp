view: no_purch_per_order {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
      }
    }
    dimension: order_id {
      type: number
    }
    dimension: order_item_count {
      type: number
    }

}
