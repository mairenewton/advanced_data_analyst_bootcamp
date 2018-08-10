view: order_item_ndt {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        derived_column: sales_rank {
          sql:  RANK(total_revenue) OVER (ORDER BY total_revenue DESC) ;;
        }
      }
    }
    dimension: order_id {
      primary_key:  yes
      type: number
    }
    dimension: order_item_count {
      type: number
    }
    dimension: total_revenue {
      type: number
    }

    dimension: sales_rank {
      type: number
    }
  }
