view: user_facts_ndt {
  # If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

    derived_table: {
      explore_source: users {
        column: id {}
        column: order_count { field: order_items.order_count }
        column: total_revenue { field: order_items.total_revenue }
        column: order_item_count { field: order_items.order_item_count }
        bind_filters: {
          from_field: user_facts_ndt.date
          to_field: order_items.created_date
        }
      }
    }

    filter: date {
      type: date
    }
    dimension: id {
      type: number
    }
    dimension: order_count {
      description: "A count of unique orders"
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_item_count {
      type: number
    }
  }
