view: user_facts_ndt {
# If necessary, uncomment the line below to include explore_source.
#  include: "advanced_data_analyst_bootcamp.model.lkml"
    derived_table: {
      explore_source: order_items {
        column: user_id { field: users.id }
        column: order_count { field: order_items.order_count}
        column: total_revenue {}
      }
    }
    dimension: user_id {
      primary_key: yes
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

  measure: count {
    type:  count
    }
  }
