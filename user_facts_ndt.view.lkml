view: user_facts_ndt {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: order_count {}
        column: order_item_count {}
        column: total_revenue {}
        derived_column: row_number {
          sql: rownumber() ;;
        }
      }
    }
    dimension: id {
      primary_key: yes
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
