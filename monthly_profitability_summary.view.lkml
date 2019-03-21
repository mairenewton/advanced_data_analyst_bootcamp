include: "advanced_data_analyst_bootcamp.model.lkml"

explore: monthly_profitability_summary {}

view: monthly_profitability_summary {
  derived_table: {
    explore_source: order_items {
      column: created_month {}
      column: total_profit {}
      column: order_item_count {}
      derived_column: total_profit_per_item {
        sql: total_profit/order_item_count ;;
      }
      derived_column: total_profit_per_item_last_year {
        sql: LAG(total_profit/order_item_count, 12) OVER (ORDER BY created_month ASC)  ;;
      }
    }
  }
  dimension: created_month {
    description: "When the order was created"
    type: date_month
  }
  dimension: total_profit {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_profit_per_item {
    type: number
    value_format_name: usd
  }
  dimension: total_profit_per_item_last_year {
    type: number
    value_format_name: usd
  }
}
