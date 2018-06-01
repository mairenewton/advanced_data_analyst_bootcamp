view: order_facts_ndt {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        bind_filters: {
          from_field: order_facts_ndt.date
          to_field: order_items.created_date
        }
      }
    }

    filter: date {
      type: date
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
  }
