# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: order_facts2 {
  derived_table: {
    explore_source: order_items {
      column: order_item_count {}
      column: order_id {}
      column: total_revenue {}
      derived_column: order_revenue_rank{
        sql: rank() over(order by total_revenue desc) ;;
      }
      filters: {
        field: order_items.date_range
        value: "7 days"
      }
    }
  }
  dimension: order_item_count {
    type: number
  }
  dimension: order_id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
