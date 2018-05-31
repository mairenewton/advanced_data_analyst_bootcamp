
  view: order_summary_ndt {
    derived_table: {
      explore_source: order_items {
        column: order_item_count {}
        column: total_revenue {}
        column: order_id {}
      }
    datagroup_trigger: order_item_datagroup
    sortkeys: ["id"]
    distribution: "id"
    }
    dimension: order_items_count {
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_id {
      primary_key: yes
      type: number
    }
  }
