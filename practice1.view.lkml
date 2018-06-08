view: practice1 {

    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        derived_column: rev_rank  {
          sql: row_number () OVER(PARTITION BY order_id ORDER BY total_revenue DESC)  ;;
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
