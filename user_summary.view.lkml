# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: order_facts_v1 {
  derived_table: {
    datagroup_trigger: order_items
    distribution: "order_id"
    sortkeys: ["order_id"]
    explore_source: order_items {
      column: order_id {}
      column: order_count {}
      column: total_revenue {}
      derived_column: rank {
        sql: rank() over (order by total_revenue desc) ;;

      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: average_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: rank {
    type: number
    sql:$user_summary.rank ;;
  }
}
