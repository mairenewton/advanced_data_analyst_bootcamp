view: user_facts {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: unique_order_count {}
        column: total_sales {}
        derived_column: row {}
      }
    }
    dimension: id {
      primary_key: yes
      type: number
    }
    dimension: unique_order_count {
      type: number
    }
    dimension: total_sales {
      type: number
    }
  }
