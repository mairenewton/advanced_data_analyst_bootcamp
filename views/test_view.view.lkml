view: test_view  {
    derived_table: {
      explore_source: users {
        column: created_date { field: order_items.created_date }
        column: order_id { field: order_items.order_id }
        filters: {
          field: order_items.date_range
          value: "7 days"
        }
      }
    }
    dimension: created_date {
      description: "When the order was created"
      type: date
    }
    dimension: order_id {
      type: number
    }
  }
