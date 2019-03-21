# If necessary, uncomment the line below to include explore_source.

include: "advanced_data_analyst_bootcamp.model.lkml"

explore: order_facts_ndt {}

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: order_item_count {}
      column: total_revenue {}
      derived_column: order_revenue_rank {
        sql: RANK() OVER (ORDER BY total_revenue DESC) ;;
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
    value_format_name: usd
    type: number
  }

  dimension: order_revenue_rank {
    type: number
  }
}
