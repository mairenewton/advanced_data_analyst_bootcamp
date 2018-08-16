view: order_facts_ndt {
  view_label: "Order Items"
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: order_item_count {}
      column: total_revenue {}
      derived_column: revenue_rank {
        sql: RANK() OVER (ORDER BY total_revenue DESC) ;;
      }
    }
    datagroup_trigger: default
#     sql_trigger_value: select max(created_at) from order_items ;;
#     persist_for: "1 hour"
    indexes: ["order_id"]
    distribution: "order_id"
#     sortkeys: ["order_id"]
  }
  dimension: order_id {
    primary_key: yes
    type: number
    hidden: yes
  }
  dimension: order_item_count {
    type: number
    hidden: yes
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
    hidden: yes
  }

  dimension: revenue_rank {
    type: number
  }
}
