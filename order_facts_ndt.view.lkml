# If necessary, uncomment the line below to include explore_source.
include: "advanced_data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    datagroup_trigger: order_facts_ndt_datagroup
    distribution: "order_id"
    sortkeys: ["order_id"]
    explore_source: order_items {
      column: order_id {}
      column: order_item_count {}
      column: total_revenue {}
      derived_column: order_rank {
        sql: RANK() OVER(ORDER BY total_revenue) ;;
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

  dimension: order_rank {
    type: number
  }

  measure: average_total_order_revenue {
    type: average
    sql: ${total_revenue};;
  }
}
