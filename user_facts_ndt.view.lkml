
# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count { field: inventory_items.count }
        column: total_sales {}
        column: order_count {}
      }
    }
    dimension: user_id {
      type: number
    }
    dimension: count {
      type: number
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_count {
      type: number
    }



    measure: avg_order_count {
      type: average
      sql: ${order_count} ;;
    }

    measure: avg_sales {
      type: average
      sql: ${total_sales} ;;
    }








  }
