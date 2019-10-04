# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: monthly_profitability_summary {
  derived_table: {
    explore_source: order_items {
      column: total_revenue {}
      column: city { field: users.city }
      column: order_item_count {}
      column: order_id {}
      filters: {
        field: users.country
        value: "USA"
      }
    }
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: city {}

  dimension: order_item_count {
    type: number
  }

  dimension: order_id {
    primary_key: yes
    type: number
  }

  measure: average_order_value{
    type: average
    sql: ${total_revenue} ;;
    value_format_name: usd
  }

  measure: average_order_item_count {
    type: average
    sql: ${order_item_count} ;;
  }

}
