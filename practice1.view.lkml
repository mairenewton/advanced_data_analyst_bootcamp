view: practice1 {

    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        derived_column: rev_rank  {
          sql: rank () OVER(ORDER BY total_revenue DESC)  ;;
        }
      }
    }
    dimension: order_id {
      primary_key: yes
      type: number
    }
    dimension: order_item_count {
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
  dimension: rev_rank {
    type: number
  }
  }
