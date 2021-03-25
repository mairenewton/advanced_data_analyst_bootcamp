view: ndt_user_facts {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: total_revenue {field: order_items.total_revenue}
        column: order_count {field: order_items.order_count}
      }
    }
    dimension: id {
      type: number
      sql: ${TABLE}.id ;;
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
      sql: ${TABLE}.total_revenue ;;
    }
    dimension: order_count {
      description: "A count of unique orders"
      type: number
      sql: ${TABLE}.order_count ;;
    }
  }
