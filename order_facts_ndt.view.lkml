view: order_facts_ndt {
# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

    derived_table: {
      datagroup_trigger: order_items
      distribution: "order_id"
      sortkeys: ["order_id"]
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
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

    measure: average_order_items_per_order {
      type: average
      sql: ${order_item_count} ;;
      value_format_name: decimal_2
    }
  }
